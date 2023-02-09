terraform {
  required_version = ">=1.1.5"

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

resource "azurerm_linux_web_app" "web_app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  https_only          = true

  site_config {
    scm_type                  = var.scm_type # TODO: gone!
    always_on                 = var.always_on
    dotnet_framework_version  = var.dotnet_framework_version # TODO: gone! maybe changed to `dotnet_version` in the `application_stack` block
    websockets_enabled        = var.websockets_enabled
    linux_fx_version          = var.linux_fx_version # TODO: gone!
    health_check_path         = var.health_check_path
    use_32_bit_worker         = var.use_32_bit_worker
    ftps_state                = var.ftps_state
    http2_enabled             = true
    minimum_tls_version       = 1.2
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  // Configures a mountpoint to a storage container (ro) or file share (rw)
  // Read more: https://docs.microsoft.com/en-us/azure/app-service/configure-connect-to-azure-storage
  dynamic "storage_account" {
    for_each = var.storage_mount == null ? [] : [1]
    content {
      name         = var.storage_mount.name
      type         = var.storage_mount.type
      account_name = var.storage_mount.account_name
      access_key   = var.storage_mount.access_key
      share_name   = var.storage_mount.share_name
      mount_path   = var.storage_mount.mount_path
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to virtual_network_subnet_id, because we use `app_service_virtual_network_swift_connection`
      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#virtual_network_subnet_id
      virtual_network_subnet_id,
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_linux_web_app.web_app.id
  subnet_id      = var.integration_subnet_id
}

resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.private_subnet_id == null ? 0 : 1
  name                = "pe-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "psc-${var.name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.web_app.id
    subresource_names              = ["sites"]
  }

  # Should be deployed by Azure policy
  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  for_each            = var.custom_domains
  hostname            = each.value
  app_service_name    = azurerm_linux_web_app.web_app.name
  resource_group_name = var.resource_group_name
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_linux_web_app.web_app.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_linux_web_app.web_app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  # TODO: Deprecated https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting#log
  # `log` is deprecated in favour of the `enabled_log` property and will be removed in version 4.0 of the AzureRM Provider.
  dynamic "log" {
    # TODO: Deprecated https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories#logs
    # `logs` is deprecated and will be removed in favour of the property `log_category_types` and `log_category_groups` in version 4.0 of the AzureRM Provider.
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
