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

resource "azurerm_storage_account" "storage_account" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.kind
  account_tier              = var.tier
  account_replication_type  = var.replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  allow_blob_public_access  = var.allow_public_access
  min_tls_version           = var.min_tls_version
  nfsv3_enabled             = var.nfsv3_enabled
  is_hns_enabled            = var.is_hns_enabled

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = var.subnet_ids
  }

  dynamic "azure_files_authentication" {
    for_each = var.authentication_directory_type == null ? [] : [1]
    content {
      directory_type = var.authentication_directory_type
    }
  }
}


# resource "azurerm_storage_account_network_rules" "example" {
#   storage_account_id = azurerm_storage_account.storage_account.id
#   default_action             = "Deny"
#   virtual_network_subnet_ids = var.subnet_ids
# }
