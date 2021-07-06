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

data "azurerm_key_vault_secret" "mysql_admin_user" {
  name         = var.mysql_admin_user_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "mysql_admin_password" {
  name         = var.mysql_admin_password_secret_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = var.mysql_server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = data.azurerm_key_vault_secret.mysql_admin_user.value
  administrator_login_password = data.azurerm_key_vault_secret.mysql_admin_password.value

  sku_name   = var.mysql_server_sku
  storage_mb = var.mysql_server_max_storage
  version    = var.mysql_server_version

  auto_grow_enabled                 = var.mysql_server_auto_grow_enabled
  backup_retention_days             = var.mysql_server_backup_retention_days
  geo_redundant_backup_enabled      = var.mysql_server_geo_redundant_backup_enabled
  infrastructure_encryption_enabled = var.mysql_server_infrastructure_encryption_enabled
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mysql_database" {
  name                = var.mysql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = var.mysql_database_charset
  collation           = var.mysql_database_collation
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mysql_server.mysql_server.id
    subresource_names              = ["mysqlServer"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group_name == "" ? [] : [1]
    content {
      name                 = var.private_dns_zone_group_name
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }
}
