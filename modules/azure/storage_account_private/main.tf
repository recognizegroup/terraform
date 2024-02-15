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

resource "azurerm_storage_account" "storage_account" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.kind
  account_tier                    = var.tier
  account_replication_type        = var.replication_type
  enable_https_traffic_only       = var.enable_https_traffic_only
  allow_nested_items_to_be_public = false
  min_tls_version                 = var.min_tls_version
  nfsv3_enabled                   = var.nfsv3_enabled
  is_hns_enabled                  = var.is_hns_enabled

  network_rules {
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "pe-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${var.name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id == null ? [] : [1]
    content {
      name = "pdzg-${var.name}"

      private_dns_zone_ids = [
        var.private_dns_zone_id,
      ]
    }
  }
}
