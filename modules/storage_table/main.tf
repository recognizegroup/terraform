terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.70.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_table" "storage_table" {
  name                 = var.storage_table_name
  storage_account_name = var.storage_account_name
}