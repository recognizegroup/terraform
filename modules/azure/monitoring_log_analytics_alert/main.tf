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
    action_group  = [var.action_group_id]
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
