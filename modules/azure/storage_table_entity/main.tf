terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_table_entity" "storage_table_entity" {
  table_name           = var.storage_table_name
  storage_account_name = var.storage_account_name

  partition_key = var.partition_key
  row_key       = var.row_key

  entity = var.entity

  lifecycle {
    ignore_changes = [
      entity
    ]
  }
}
