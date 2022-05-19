terraform {
  required_version = ">=1.1.3"

  required_providers {
    azurerm = "=2.88.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = var.name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name
}
