terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_storage_table" "storage_table" {
  name                 = var.storage_table_name
  storage_account_name = var.storage_account_name
}
