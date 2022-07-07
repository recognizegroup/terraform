terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = "=3.10.0"
  }

  backend "azurerm" {}

  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name
  enabled             = var.action_group_enabled

  email_receiver {
    name                    = "Send email"
    email_address           = var.action_group_email_receiver
    use_common_alert_schema = var.action_group_use_common_alert_schema
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "query_alert" {
  for_each = {
    for rule in var.monitoring_rules :
    rule.name => rule
  }
  name                = each.value.name
  description         = each.value.description
  enabled             = each.value.enabled
  location            = var.location
  resource_group_name = var.resource_group_name
  data_source_id      = each.value.data_source_id

  action {
    action_group  = [azurerm_monitor_action_group.action_group.id]
    email_subject = "Monitoring Alert"
  }

  query                   = each.value.query
  severity                = each.value.severity
  frequency               = each.value.frequency
  time_window             = each.value.time_window
  auto_mitigation_enabled = each.value.auto_mitigation_enabled

  trigger {
    operator  = each.value.operator
    threshold = each.value.threshold
  }
}
