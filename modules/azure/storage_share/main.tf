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
