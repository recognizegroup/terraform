terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  rules = { for rule in var.monitoring_rules : rule.name => rule }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "log_search_alert" {
  for_each = local.rules

  name                    = each.value.name
  description             = each.value.description
  enabled                 = each.value.enabled
  location                = var.location
  resource_group_name     = var.resource_group_name
  scopes                  = [each.value.scope]
  severity                = each.value.severity
  evaluation_frequency    = each.value.evaluation_frequency
  window_duration         = each.value.window_duration
  auto_mitigation_enabled = each.value.auto_mitigation_enabled
  skip_query_validation   = each.value.skip_query_validation
  tags                    = var.tags

  criteria {
    query                   = each.value.query
    time_aggregation_method = "Count"
    operator                = each.value.operator
    threshold               = each.value.threshold

    dynamic "dimension" {
      for_each = each.value.dimensions

      content {
        name     = dimension.value
        operator = "Include"
        values   = ["*"]
      }
    }

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = var.action_group_ids
  }

  identity {
    type = "SystemAssigned"
  }
}
