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

resource "azurerm_recovery_services_vault" "vault" {
  name                = var.recovery_services_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.recovery_services_vault_sku
}

resource "azurerm_backup_policy_vm" "backup_policy" {
  name                = var.backup_policy_vm_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.backup_policy_vm_timezone

  backup {
    frequency = var.backup_policy_vm_frequency
    time      = var.backup_policy_vm_time
  }

  retention_daily {
    count = var.backup_policy_vm_retention
  }
}

resource "azurerm_backup_protected_vm" "vm_backup" {
  for_each            = toset(var.source_vm_ids)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = each.key
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy.id
}
