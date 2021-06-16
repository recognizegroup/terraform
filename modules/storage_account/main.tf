terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.41.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "storage_account" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.storage_account_kind
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication_type
  enable_https_traffic_only = true
}


resource "azurerm_storage_container" "blob_container" {
  for_each = var.container_names
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
