terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_queue" "storage_queue" {
  for_each             = var.queue_names
  name                 = each.value
  storage_account_name = var.storage_account_name
}
