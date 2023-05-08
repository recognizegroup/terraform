terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "random_password" "mssql_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
  keepers          = var.password_keeper
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

resource "azurerm_mssql_server" "mssql_server" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.server_version
  administrator_login           = var.admin_username
  administrator_login_password  = random_password.mssql_admin_password.result
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"

  dynamic "azuread_administrator" {
    for_each = var.administrator_object_id == null ? [] : [1]
    content {
      login_username = "AzureAD Admin"
      object_id      = var.administrator_object_id
      tenant_id      = data.azurerm_client_config.current.tenant_id
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_server_transparent_data_encryption" "encryption" {
  server_id = azurerm_mssql_server.mssql_server.id
}

resource "azurerm_mssql_database" "mssql_database" {
  name                                = var.database_name
  server_id                           = azurerm_mssql_server.mssql_server.id
  sku_name                            = var.database_sku
  min_capacity                        = var.min_capacity
  auto_pause_delay_in_minutes         = var.auto_pause_delay
  transparent_data_encryption_enabled = true

  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_days == null ? [] : [1]

    content {
      retention_days = var.short_term_retention_days
    }
  }
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "pe-${var.server_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${var.server_name}"
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  # Should be deployed by Azure policy
  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_mssql_database.mssql_database.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.database_name}"
  target_resource_id         = azurerm_mssql_database.mssql_database.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].log_category_types

    content {
      category = enabled_log.value

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
