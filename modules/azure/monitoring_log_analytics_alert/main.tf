terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. If 3.89 is released, we can upgrade to that
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
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
