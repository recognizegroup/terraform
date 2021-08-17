terraform {
  required_version = ">=0.14.0"

  required_providers {
    azurerm = "=2.51.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_application_insights" "ai" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
}
