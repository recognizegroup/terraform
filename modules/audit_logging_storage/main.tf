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
  name                     = var.audit_logging_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.audit_logging_storage_account_kind
  account_tier             = var.audit_logging_storage_account_tier
  account_replication_type = var.audit_logging_storage_replication_type
}
