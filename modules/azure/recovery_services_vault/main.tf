terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
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
