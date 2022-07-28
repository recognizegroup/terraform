terraform {
  required_version = ">=0.13.4"

  required_providers {
    azurerm = ">=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network_peering" "virtual_network_peering" {
  name                      = var.virtual_network_peering_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = var.remote_virtual_network_id
}
