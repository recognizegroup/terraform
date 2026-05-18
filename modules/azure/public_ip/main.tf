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

resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  domain_name_label   = var.domain_name_label
  sku                 = var.sku
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.loganalytics_diagnostic_setting == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_public_ip.public_ip.id
  log_analytics_workspace_id = var.loganalytics_diagnostic_setting.workspace_id


  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

