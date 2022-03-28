terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.70.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_queue" "storage_queue" {
  for_each             = var.queue_names
  name                 = each.value
  storage_account_name = var.storage_account_name
}