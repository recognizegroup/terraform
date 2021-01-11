terraform {
  required_version = ">=0.14.4"

  required_providers {
    azurerm = "=2.41.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_provider_registration" "cost_management_export_registration" {
  name = "Microsoft.CostManagementExports"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.cost_management_export_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.cost_management_export_storage_account_kind
  account_tier             = var.cost_management_export_storage_account_tier
  account_replication_type = var.cost_management_export_storage_account_replication_type
}

resource "azurerm_cost_management_export_resource_group" "cost_management_export" {
  name                    = var.cost_management_export_name
  resource_group_id       = var.resource_group_id
  recurrence_type         = "Monthly"
  recurrence_period_start = "2021-02-01T00:00:00Z"
  recurrence_period_end   = "2021-12-31T00:00:00Z"

  delivery_info {
    storage_account_id = azurerm_storage_account.storage_account.id
    container_name     = var.cost_management_export_container_name
    root_folder_path   = var.cost_management_export_root_folder_path
  }

  query {
    type       = var.cost_management_export_type
    time_frame = var.cost_management_export_time_frame
  }
}

