terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  daily_quota_gb      = var.daily_quota_gb
}



resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                          = var.loganalytics_diagnostic_setting == null ? 0 : 1
  name                           = "diag-${var.name}"
  target_resource_id             = azurerm_log_analytics_workspace.workspace.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.id
  log_analytics_destination_type = var.loganalytics_diagnostic_setting.destination_type == null ? null : var.loganalytics_diagnostic_setting.destination_type

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

