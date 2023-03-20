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

# Function App

resource "azurerm_linux_function_app" "function_app" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = var.service_plan_id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = var.storage_account_access_key
  functions_extension_version = var.runtime_version

  app_settings = var.app_settings

  site_config {
    always_on              = var.always_on
    vnet_route_all_enabled = var.route_all_outbound_traffic
    ip_restriction         = var.ip_restriction
  }

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
}

# VNet integration

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_linux_function_app.function_app.id
  subnet_id      = var.integration_subnet_id
}

# Logging and analytics

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_linux_function_app.function_app.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_linux_function_app.function_app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

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
