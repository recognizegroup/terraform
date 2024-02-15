terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
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
