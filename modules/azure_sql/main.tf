terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.41.0"
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

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.nw_resource_group_name
}

resource "azurerm_mssql_server" "sql_server" {
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

resource "azurerm_mssql_database" "sql_database" {
  name                        = var.sql_database_name
  server_id                   = azurerm_mssql_server.sql_server.id
  sku_name                    = var.sql_database_sku
  min_capacity                = var.sql_database_min_capacity
  auto_pause_delay_in_minutes = var.sql_database_auto_pause_delay

  short_term_retention_policy {
    retention_days = var.short_term_retention_days
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_sql_virtual_network_rule" "sql_vnet_rule" {
  name                = var.sql_vnet_rule_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sql_server.name
  subnet_id           = data.azurerm_subnet.subnet.id
}
