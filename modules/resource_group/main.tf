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

resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
}
