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

resource "azurerm_storage_table_entity" "storage_table_entity" {
  for_each = { for entity in var.rows : entity.row_key => entity }

  table_name           = var.storage_table_name
  storage_account_name = var.storage_account_name

  partition_key = each.value.partition_key
  row_key       = each.value.row_key

  entity = each.value.entity

  lifecycle {
    ignore_changes = [
      entity
    ]
  }
}
