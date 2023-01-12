terraform {
  required_version = ">=0.14.9"

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

resource "azurerm_monitor_diagnostic_setting" "setting" {
  name               = var.name
  target_resource_id = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  metric {
    category = var.metric_category
    retention_policy {
      enabled = var.metric_retention_policy_enabled
    }
  }
}
