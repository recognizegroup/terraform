terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = ">=2.41.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_data_factory" "data_factory" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
  location            = var.location
}
