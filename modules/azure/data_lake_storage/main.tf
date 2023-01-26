terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "storage_account" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.kind
  account_tier                    = var.tier
  account_replication_type        = var.replication_type
  is_hns_enabled                  = true
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = var.min_tls_version


  # Enables recommended data protection configuration
  # https://docs.microsoft.com/en-us/azure/storage/blobs/versioning-overview#recommended-data-protection-configuration
  blob_properties {
    versioning_enabled = var.blob_versioning_enabled

    dynamic "delete_retention_policy" {
      for_each = var.blob_retention_days == null ? [] : [1]
      content {
        days = var.blob_retention_days
      }
    }

    dynamic "container_delete_retention_policy" {
      for_each = var.container_retention_days == null ? [] : [1]
      content {
        days = var.container_retention_days
      }
    }
  }
}

// HACK: Role assignment is needed to apply adls gen2 filesystem changes
resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

// HACK: Sleep is needed to wait for role assignment to propagate
resource "time_sleep" "role_assignment_sleep" {
  create_duration = "60s"

  triggers = {
    role_assignment = azurerm_role_assignment.role_assignment.id
  }
}

resource "azurerm_private_endpoint" "private_endpoint_blob" {
  name                = "pe-blob-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-blob-${var.name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }

  # Should be deployed by Azure policy
  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_dfs" {
  name                = "pe-dfs-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-dfs-${var.name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["dfs"]
  }

  # Should be deployed by Azure policy
  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

# FIXME: https://github.com/hashicorp/terraform-provider-azurerm/issues/6659
data "http" "ip" {
  url = "https://ifconfig.me"
}

resource "azurerm_storage_account_network_rules" "storage_account_network_rules" {
  storage_account_id         = azurerm_storage_account.storage_account.id
  default_action             = var.network_default_action
  ip_rules                   = concat(var.network_ip_rules, [data.http.ip.body])
  virtual_network_subnet_ids = var.network_subnet_ids
  bypass                     = ["Logging", "Metrics", "AzureServices"]
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_storage_account.storage_account.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_storage_account.storage_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].logs

    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
}
