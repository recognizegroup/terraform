terraform {
  required_version = ">=1.1.5"

  required_providers {
    azurerm = "=2.96.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_share" "storage_share" {
  name                 = var.name
  storage_account_name = var.storage_account_name
  quota                = var.quota
  enabled_protocol     = var.enabled_protocol
}

resource "azurerm_storage_share_directory" "folder_name" {
  for_each = var.directories == null ? [] : toset(var.directories)

  name                 = each.key
  share_name           = azurerm_storage_share.storage_share.name
  storage_account_name = azurerm_storage_share.storage_share.storage_account_name
}
