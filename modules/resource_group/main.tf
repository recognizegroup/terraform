terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}
