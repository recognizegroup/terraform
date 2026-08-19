terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_data_collection_endpoint" "data_collection_endpoint" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = var.kind
  public_network_access_enabled = var.public_network_access_enabled
  description                   = var.description
  tags                          = var.tags
}
