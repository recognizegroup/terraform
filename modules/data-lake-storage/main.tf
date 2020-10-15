terraform {
  required_version = ">=0.13.3"

  required_providers {
    azurerm = "=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = var.skip_provider_registration
  features {}
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.datalake_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.datalake_storage_account_tier
  account_replication_type = var.datalake_storage_replication_type
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "storage_container" {
  name                 = var.datalake_storage_container_name
  storage_account_name = azurerm_storage_account.storage_account.name
}
