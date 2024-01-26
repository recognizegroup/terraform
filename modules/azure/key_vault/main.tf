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

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_template_deployment = var.enabled_for_template_deployment
  sku_name                        = var.sku
  enable_rbac_authorization       = var.enable_rbac

  // Set secrets administrator policy
  dynamic "access_policy" {
    for_each = {
      for index, object_id in distinct(concat(var.secret_administrators, var.add_current_principal_as_administrator ? [] : [data.azurerm_client_config.current.object_id])) :
      object_id => object_id if !var.enable_rbac
    }

    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "Purge"
      ]
      certificate_permissions = []
      key_permissions         = []
      storage_permissions     = []
    }
  }

  // Set secrets reader policy
  dynamic "access_policy" {
    for_each = {
      for index, object_id in var.secret_readers :
      object_id => object_id if !contains(var.secret_administrators, object_id)
      && object_id != data.azurerm_client_config.current.object_id
    }

    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "Purge"
      ]
      certificate_permissions = []
      key_permissions         = []
      storage_permissions     = []
    }
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].log_category_types

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].metrics

    content {
      category = metric.value
      enabled  = true
    }
  }
}
