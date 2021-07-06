terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.49.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

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

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group_name == "" ? [] : [1]
    content {
      name                 = var.private_dns_zone_group_name
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }
}

resource "azurerm_management_lock" "storage_account_lock" {
  name       = "${var.datalake_storage_account_name}-lock"
  scope      = azurerm_storage_account.storage_account.id
  lock_level = "CanNotDelete"
  notes      = "Locked because deleting the resource can't be undone"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  name               = var.datalake_storage_filesystem_name
  storage_account_id = azurerm_storage_account.storage_account.id

  dynamic "ace" {
    for_each = {
      for index, permission in var.root_permissions :
      index => permission
    }
    content {
      type        = ace.value.type
      scope       = ace.value.scope
      id          = ace.value.object_id
      permissions = ace.value.permissions
    }
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "time_sleep" "role_assignment_sleep" {
  create_duration = "60s"

  triggers = {
    role_assignment = azurerm_role_assignment.role_assignment.id
  }
}

resource "azurerm_storage_data_lake_gen2_path" "path" {
  for_each           = var.datalake_storage_folders
  path               = each.value.path
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.filesystem.name
  storage_account_id = azurerm_storage_account.storage_account.id
  resource           = "directory"

  dynamic "ace" {
    for_each = each.value.permissions
    content {
      type        = ace.value.type
      scope       = ace.value.scope
      id          = ace.value.object_id
      permissions = ace.value.permissions
    }
  }

  depends_on = [
    azurerm_role_assignment.role_assignment,
    time_sleep.role_assignment_sleep
  ]
}
