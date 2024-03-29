terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  managed_resource_group_name   = var.managed_resource_group_name
  location                      = var.location
  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled

  custom_parameters {
    no_public_ip        = var.no_public_ip
    private_subnet_name = var.private_subnet_name
    public_subnet_name  = var.public_subnet_name
    virtual_network_id  = var.virtual_network_id
  }
}
