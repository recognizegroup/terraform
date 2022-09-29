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

  dynamic "network_rules" {
    for_each = var.nfsv3_enabled == true ? [] : [1]
    content {
      default_action = "Deny"
      bypass         = ["AzureServices"]
      ip_rules       = ["${chomp(data.http.icanhazip.body)}"]
    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.authentication_directory_type == null ? [] : [1]
    content {
      directory_type = var.authentication_directory_type
    }
  }
}

# Learn our public IP address
data "http" "amazonaws" {
  for_each = var.nfsv3_enabled == true ? [] : [1]
  url = "https://checkip.amazonaws.com/"
}
