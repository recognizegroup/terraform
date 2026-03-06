terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "random_password" "mysql_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
  keepers          = var.password_keeper
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = var.mysql_server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = var.mysql_admin_username
  administrator_login_password = random_password.mysql_admin_password.result

  sku_name   = var.mysql_server_sku
  storage_mb = var.mysql_server_max_storage
  version    = var.mysql_server_version

  auto_grow_enabled                 = var.storage_auto_grow_enabled
  backup_retention_days             = var.backup_retention_days
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mysql_database" "mysql_database" {
  name                = var.mysql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = var.mysql_database_charset
  collation           = var.mysql_database_collation
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "pe-${var.mysql_server_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${var.mysql_server_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mysql_server.mysql_server.id
    subresource_names              = ["mysqlServer"]
  }

  # Should be deployed by Azure policy
  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.mysql_server_name}"
  target_resource_id         = azurerm_mysql_server.mysql_server.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_mysql_configuration" "mysql_capture_mode" {
  name                = "query_store_capture_mode"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  value               = var.query_store_capture_mode
}
