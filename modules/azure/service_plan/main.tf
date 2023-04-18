terraform {
  required_version = "~> 1.1"

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

locals {
  scale_in_threshold_rules = [
    for rule in var.scaling_rules : {
      threshold   = rule.scale_in_threshold
      metric_name = rule.metric_name
      direction   = "Decrease"
      operator    = "LessThan"
    }
  ]

  scale_out_threshold_rules = [
    for rule in var.scaling_rules : {
      threshold   = rule.scale_out_threshold
      metric_name = rule.metric_name
      direction   = "GreaterThan"
      operator    = "Increase"
    }
  ]
}

resource "azurerm_service_plan" "sp" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
}

resource "azurerm_monitor_autoscale_setting" "autoscale_setting" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = "scale-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.sp.id

  profile {
    name = "scale-${var.name}"

    capacity {
      default = var.default_scaling_capacity
      minimum = var.minimum_scaling_capacity
      maximum = var.maximum_scaling_capacity
    }

    dynamic "rule" {
      for_each = concat(local.scale_in_threshold_rules, local.scale_out_threshold_rules)

      content {
        metric_trigger {
          metric_name        = rule.value.metric_name
          metric_resource_id = azurerm_service_plan.sp.id
          time_grain         = "PT1M"
          statistic          = "Average"
          time_window        = "PT5M"
          time_aggregation   = "Average"
          operator           = rule.value.operator
          threshold          = rule.value.threshold
        }

        scale_action {
          direction = rule.value.direction
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT1M"
        }
      }
    }
  }
}
