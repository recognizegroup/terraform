terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
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
}

resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name                = var.mysql_server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = var.mysql_admin_username
  administrator_login_password = random_password.mysql_admin_password.result

  backup_retention_days             = var.backup_retention_days
  delegated_subnet_id               = var.subnet_id
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  private_dns_zone_id               = var.private_dns_zone_id

  sku_name   = var.mysql_server_sku
  version    = var.mysql_server_version
  #zone = 

  public_network_access_enabled     = false
  
  storage {
    auto_grow_enabled                 = var.storage_auto_grow_enabled
    iops                              = var.mysql_server_storage_iops
    size_gb                           = var.mysql_server_storage_max
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mysql_flexible_database" "mysql_flexible_database" {
  name                = var.mysql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_flexible_server.name
  charset             = var.mysql_database_charset
  collation           = var.mysql_database_collation
}


data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_mysql_server.mysql_flexible_server.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.mysql_server_name}"
  target_resource_id         = azurerm_mysql_server.mysql_flexible_server.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].logs

    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
}

resource "azurerm_mysql_configuration" "mysql_capture_mode" {
  name                = "query_store_capture_mode"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_flexible_server.name
  value               = var.query_store_capture_mode
}
