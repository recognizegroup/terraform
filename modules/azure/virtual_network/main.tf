terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  # Deployed as a separate resource
  lifecycle {
    ignore_changes = [subnet]
  }
}


data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.loganalytics_diagnostic_setting == null ? 0 : 1
  resource_id = azurerm_virtual_network.virtual_network.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.loganalytics_diagnostic_setting == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_virtual_network.virtual_network.id
  log_analytics_workspace_id = var.loganalytics_diagnostic_setting.workspace_id


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
