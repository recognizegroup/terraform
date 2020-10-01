terraform {
  required_version = ">= 0.13.3"

  required_providers {
        azurerm = ">=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = var.skip_provider_registration
  features {}
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = var.databricks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_namespace_sku
}
