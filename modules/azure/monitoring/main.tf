terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }
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
  enabled             = var.action_group_enabled

  dynamic "email_receiver" {
    for_each = var.action_group_email_receiver == null ? [] : [1]
    content {
      name                    = "Email"
      email_address           = var.action_group_email_receiver
      use_common_alert_schema = var.action_group_use_common_alert_schema
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.action_group_webhook_uri == null ? [] : [1]
    content {
      name                    = "Webhook"
      service_uri             = var.action_group_webhook_uri
      use_common_alert_schema = var.action_group_use_common_alert_schema
    }
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
