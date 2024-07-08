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

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  daily_quota_gb      = var.daily_quota_gb
}



data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.loganalytics_diagnostic_setting == null ? 0 : 1
  resource_id = azurerm_log_analytics_workspace.workspace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                          = var.loganalytics_diagnostic_setting == null ? 0 : 1
  name                           = "diag-${var.name}"
  target_resource_id             = azurerm_log_analytics_workspace.workspace.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.id
  log_analytics_destination_type = var.loganalytics_diagnostic_setting.destination_type == null ? null : var.loganalytics_diagnostic_setting.destination_type

  dynamic "enabled_log" {
    for_each = var.loganalytics_diagnostic_setting.categories == null ? data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].log_category_types : var.loganalytics_diagnostic_setting.categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.loganalytics_diagnostic_setting.metrics == null ? data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].metrics : var.loganalytics_diagnostic_setting.metrics

    content {
      category = metric.value
      enabled  = true
    }
  }
}

