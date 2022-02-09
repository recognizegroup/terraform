terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=2.94.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_maps_account" "maps_account" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku

  # Managed by Azure Policy
  lifecycle {
    ignore_changes = [tags]
  }
}
