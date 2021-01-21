terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.37.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  email_receiver {
    name          = "Send email"
    email_address = var.action_group_email_receiver
  }
}


resource "azurerm_monitor_metric_alert" "metric_alerts" {
  for_each = var.metric_alerts

  name                = each.key
  resource_group_name = var.resource_group_name
  scopes              = each.value.scopes
  description         = each.value.description
  frequency           = each.value.frequency
  window_size         = each.value.window_size

  criteria {
    metric_namespace = each.value.criteria_metric_namespace
    metric_name      = each.value.criteria_metric_name
    aggregation      = each.value.criteria_metric_aggregation
    operator         = each.value.criteria_metric_operator
    threshold        = each.value.criteria_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }

}
