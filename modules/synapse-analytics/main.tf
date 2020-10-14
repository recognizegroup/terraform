terraform {
  required_version = ">=0.13.3"

  required_providers {
    azurerm = "=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = var.skip_provider_registration
  features {}
}

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

resource "azurerm_sql_server" "sql_server" {
  name                             = var.sql_server_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  version                          = var.sql_server_version
  administrator_login              = data.azurerm_key_vault_secret.sql_admin_user_secret.value
  administrator_login_password     = data.azurerm_key_vault_secret.sql_admin_password_secret.value
}

resource "azurerm_sql_database" "sql_database" {
  name                             = var.sql_database_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.sql_server.name
  edition                          = var.sql_edition
  requested_service_objective_name = var.sql_service_level
}
