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
  allow_blob_public_access  = var.storage_account_allow_public_access
  min_tls_version           = var.storage_account_min_tls_version
}
