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

resource "azurerm_data_factory" "data_factory" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}
