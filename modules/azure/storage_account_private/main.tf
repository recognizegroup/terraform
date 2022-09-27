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
  allow_blob_public_access  = false
  min_tls_version           = var.min_tls_version
  nfsv3_enabled             = var.nfsv3_enabled
  is_hns_enabled            = var.is_hns_enabled

  network_rules {
    default_action = "Deny"
  }

  lifecycle {
    prevent_destroy = true
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

  # Should be deployed by Azure policy
  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}
