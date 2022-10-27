terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "3.6.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_table_entity" "storage_table_entity" {
  for_each = { for entity in var.rows:  entity.row_key => entity }

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