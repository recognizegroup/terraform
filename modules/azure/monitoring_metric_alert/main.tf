terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_metric_alert" "metric_alert" {
  for_each = {
    for rule in var.monitoring_rules :
    rule.name => rule
  }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  scopes              = [each.value.monitored_resource_id]
  description         = each.value.description
  severity            = each.value.severity
  enabled             = each.value.enabled

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  action {
    action_group_id = var.action_group_id
  }
}
