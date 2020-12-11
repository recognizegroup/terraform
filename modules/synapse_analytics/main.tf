terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.37.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "sql_admin_user_secret" {
  name         = var.sql_admin_user_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "sql_admin_password_secret" {
  name         = var.sql_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.nw_resource_group_name
}

resource "azurerm_sql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = data.azurerm_key_vault_secret.sql_admin_user_secret.value
  administrator_login_password = data.azurerm_key_vault_secret.sql_admin_password_secret.value

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_sql_database" "sql_database" {
  name                             = var.sql_database_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.sql_server.name
  edition                          = var.sql_edition
  requested_service_objective_name = var.sql_service_level
}

resource "azurerm_sql_active_directory_administrator" "sql_administrator" {
  server_name         = azurerm_sql_server.sql_server.name
  resource_group_name = var.resource_group_name
  login               = var.sql_admin_login
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = var.sql_administrator_object_id
}

resource "azurerm_sql_virtual_network_rule" "sql_vnet_rule" {
  name                = var.sql_vnet_rule_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  subnet_id           = data.azurerm_subnet.subnet.id
}
