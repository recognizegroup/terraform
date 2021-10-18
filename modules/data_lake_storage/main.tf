terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.72.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "storage_account" {
  name                      = var.datalake_storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.datalake_storage_account_kind
  account_tier              = var.datalake_storage_account_tier
  account_replication_type  = var.datalake_storage_replication_type
  is_hns_enabled            = true
  enable_https_traffic_only = true
  allow_blob_public_access  = false
  min_tls_version           = var.storage_account_min_tls_version
}

resource "azurerm_management_lock" "storage_account_lock" {
  name       = "${var.datalake_storage_account_name}-lock"
  scope      = azurerm_storage_account.storage_account.id
  lock_level = "CanNotDelete"
  notes      = "Locked because deleting the resource can't be undone"
}

resource "azurerm_private_endpoint" "private_endpoint_blob" {
  name                = var.blob_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.blob_private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_dfs" {
  name                = var.dfs_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.dfs_private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["dfs"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

# FIXME: https://github.com/hashicorp/terraform-provider-azurerm/issues/6659
data "http" "ip" {
  url = "https://ifconfig.me"
}

resource "azurerm_storage_account_network_rules" "storage_account_network_rules" {
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.datalake_storage_account_name
  default_action             = "Deny"
  ip_rules                   = concat(var.datalake_storage_ip_rules, [data.http.ip.body])
  virtual_network_subnet_ids = var.datalake_storage_subnet_ids
  bypass                     = ["Logging", "Metrics", "AzureServices"]
}
