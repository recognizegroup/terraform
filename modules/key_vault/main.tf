terraform {
  required_version = ">=0.14.0"

  required_providers {
    azurerm = "=2.37.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "key_vault" {
  name                      = var.key_vault_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled       = var.soft_delete_enabled
  purge_protection_enabled  = var.purge_protection_enabled
  sku_name                  = var.key_vault_sku
  enable_rbac_authorization = var.enable_rbac_authorization
}
