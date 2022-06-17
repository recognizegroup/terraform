terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = "=2.82.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_app_service" "app_service" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id
  https_only          = true

  site_config {
    scm_type                  = var.scm_type
    always_on                 = var.always_on
    ftps_state                = "AllAllowed"
    dotnet_framework_version  = var.dotnet_framework_version
    websockets_enabled        = var.websockets_enabled
    linux_fx_version          = var.linux_fx_version
    min_tls_version           = var.min_tls_version
    health_check_path         = var.health_check_path
    use_32_bit_worker_process = var.use_32_bit_worker_process
  }

  app_settings = var.app_settings

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "auth_settings" {
    for_each = var.auth_enabled == null ? [] : [1]
    content {
      enabled                       = var.auth_enabled
      default_provider              = var.auth_default_provider
      issuer                        = var.auth_issuer
      unauthenticated_client_action = var.unauthenticated_client_action
      active_directory {
        client_id         = var.client_id
        client_secret     = var.client_secret
        allowed_audiences = var.allowed_audiences
      }
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_app_service.app_service.id
  subnet_id      = var.integration_subnet_id
}

resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  for_each            = toset(var.custom_domains)
  hostname            = each.value
  app_service_name    = azurerm_app_service.app_service.name
  resource_group_name = var.resource_group_name
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_app_service.app_service.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_app_service.app_service.id
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
