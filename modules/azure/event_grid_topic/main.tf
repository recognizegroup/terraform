terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_eventgrid_system_topic" "topic" {
  name                   = var.topic_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  source_arm_resource_id = var.source_arm_resource_id
  topic_type             = var.topic_type
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.loganalytics_diagnostic_setting == null ? 0 : 1
  resource_id = azurerm_eventgrid_system_topic.topic.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.loganalytics_diagnostic_setting == null ? 0 : 1
  name                       = "diag-${var.topic_name}"
  target_resource_id         = azurerm_eventgrid_system_topic.topic.id
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
