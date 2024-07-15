terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "random_password" "postgresql_admin" {
  length           = 16
  special          = false
  override_special = "_%@"
  keepers          = var.password_keeper
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

resource "azurerm_postgresql_flexible_server" "postgresql_server" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.postgresql_sku_name

  storage_mb                    = var.postgresql_db_size
  backup_retention_days         = 30
  public_network_access_enabled = var.public_network_access_enabled

  administrator_login    = var.admin_username
  administrator_password = random_password.postgresql_admin.result
  version                = var.postgresql_version
  zone                   = var.postgresql_zone
  delegated_subnet_id    = var.delegated_subnet_id
  private_dns_zone_id    = var.private_dns_zone_id

  maintenance_window {
    day_of_week  = 1 # Monday
    start_hour   = 2
    start_minute = 0
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "postgresql_database" {
  name      = var.postgresql_database_name
  server_id = azurerm_postgresql_flexible_server.postgresql_server.id
  charset   = "UTF8"
  collation = var.postgresql_database_collation

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_configuration" "configuration_query_capture_mode" {
  name      = "pg_qs.query_capture_mode"
  server_id = azurerm_postgresql_flexible_server.postgresql_server.id
  value     = "TOP"
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_postgresql_flexible_server.postgresql_server.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_postgresql_flexible_server.postgresql_server.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].log_category_types

    content {
      category = enabled_log.value

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
