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
  autoscaling_memoryRules = var.memory_scaling_settings != null ? [
    {
      threshold = var.memory_scaling_settings.scale_in_threshold
      metric    = "MemoryPercentage"
      direction = "Decrease"
      operator  = "LessThan"
    },
    {
      threshold = var.memory_scaling_settings.scale_out_threshold
      metric    = "MemoryPercentage"
      operator  = "GreaterThan"
      direction = "Increase"
    }
  ] : []

  autoscaling_CpuRules = var.cpu_scaling_settings != null ? [
    {
      threshold = var.cpu_scaling_settings.scale_in_threshold
      metric    = "MemoryPercentage"
      direction = "Decrease"
      operator  = "LessThan"
    },
    {
      threshold = var.cpu_scaling_settings.scale_out_threshold
      metric    = "MemoryPercentage"
      operator  = "GreaterThan"
      direction = "Increase"
    }
  ] : []
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
      for_each = concat(local.autoscaling_memoryRules, local.autoscaling_CpuRules)
      content {
        metric_trigger {
          metric_name        = rule.value.metric
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
