terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=2.96.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_servicebus_namespace" "service_bus" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
}
