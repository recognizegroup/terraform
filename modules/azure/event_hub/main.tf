terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_eventhub_namespace" "namespace" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.namespace_sku
  capacity            = var.namespace_capacity
}

resource "azurerm_eventhub" "eventhub" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_consumer_group" "consumer" {
  name                = var.consumer_group_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = var.resource_group_name
}


data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.loganalytics_diagnostic_setting == null ? 0 : 1
  resource_id = azurerm_eventhub_namespace.namespace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                          = var.loganalytics_diagnostic_setting == null ? 0 : 1
  name                           = "diag-${var.namespace_name}"
  target_resource_id             = azurerm_eventhub_namespace.namespace.id
  log_analytics_workspace_id     = var.loganalytics_diagnostic_setting.workspace_id
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
