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

resource "azurerm_storage_account" "storage_account" {
  name                     = var.cost_management_export_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.cost_management_export_storage_account_kind
  account_tier             = var.cost_management_export_storage_account_tier
  account_replication_type = var.cost_management_export_storage_account_replication_type
}

resource "azurerm_storage_container" "container" {
  name                  = var.cost_management_export_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_cost_management_export_resource_group" "cost_management_export" {
  name                    = var.cost_management_export_name
  resource_group_id       = var.resource_group_id
  recurrence_type         = var.cost_management_export_recurrence_type
  recurrence_period_start = var.cost_management_export_recurrence_period_start
  recurrence_period_end   = var.cost_management_export_recurrence_period_end

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

resource "azurerm_template_deployment" "cost_management_logic_app" {
  name                = var.cost_management_logic_app_workflow_name
  resource_group_name = var.resource_group_name
  template_body       = file("logic_app_template.json")

  parameters = {
    workflow_name                       = var.cost_management_logic_app_workflow_name
    cost_management_export_name         = var.cost_management_export_name
    cost_management_storage_container   = var.cost_management_export_container_name
    cost_management_storage_root_folder = var.cost_management_export_root_folder_path
    send_to                             = var.send_export_to
    cc                                  = var.send_export_to_cc
  }

  deployment_mode = "Incremental"
}
