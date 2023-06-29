terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_storage_share" "storage_share" {
  name                 = var.name
  storage_account_name = var.storage_account_name
  quota                = var.quota
  enabled_protocol     = var.enabled_protocol
}

resource "azurerm_storage_share_directory" "folder_name" {
  for_each = var.directories_to_create == null ? [] : toset(var.directories_to_create)

  name                 = each.key
  share_name           = azurerm_storage_share.storage_share.name
  storage_account_name = azurerm_storage_share.storage_share.storage_account_name
}
