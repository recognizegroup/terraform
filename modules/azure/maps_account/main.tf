terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
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
