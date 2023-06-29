terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
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
