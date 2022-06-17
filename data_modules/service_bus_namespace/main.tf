terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_servicebus_namespace" "service_bus_namespace" {
  name                = var.service_bus_namespace
  resource_group_name = var.resource_group_name
}
