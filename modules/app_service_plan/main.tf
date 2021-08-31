terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.72.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_app_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan_kind
  reserved            = var.app_service_plan_kind == "Linux" ? true : false

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }
}

resource "azurerm_monitor_autoscale_setting" "example" {
  count               = var.app_service_autoscaling_name == "" ? 0 : 1
  name                = var.app_service_autoscaling_name
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_app_service_plan.asp.id

  profile {
    name = var.app_service_autoscaling_name

    capacity {
      default = var.app_service_default_capacity
      minimum = var.app_service_minimum_capacity
      maximum = var.app_service_maximum_capacity
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.asp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
}
