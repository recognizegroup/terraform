terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.67.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_integration_service_environment" "ise" {
  name                       = var.ise_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku_name                   = var.sku_name
  access_endpoint_type       = var.access_endpoint_type
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
}
