terraform {
  required_version = ">=1.0.11"

  required_providers {
    azurerm = "=2.52.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  resource_group_name = var.nw_resource_group_name
}

resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                        = var.databricks_workspace_name
  resource_group_name         = var.resource_group_name
  managed_resource_group_name = var.managed_resource_group_name
  location                    = var.location
  sku                         = var.databricks_sku

  custom_parameters {
    no_public_ip        = var.no_public_ip
    private_subnet_name = var.private_subnet_name
    public_subnet_name  = var.public_subnet_name
    virtual_network_id  = data.azurerm_virtual_network.virtual_network.id
  }
}
