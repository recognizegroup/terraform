terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=3.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# resource "azurerm_storage_container" "storage_container" {
#   name                  = var.storage_container_name
#   storage_account_name  = var.storage_account_name
#   container_access_type = var.storage_container_access_type
# }

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = var.storage_container_name
  storage_account_id = var.storage_account_id

  # owner = "$superuser"
  # group = "$superuser"

  ace {
    type        = "other"
    permissions = "rwx"
  }

  ace {
    scope      = "default"
    type        = "other"
    permissions = "rwx"
  }

  ace {
    scope      = "default"
    type        = "group"
    permissions = "rwx"
  }

  ace {
    scope      = "default"
    type        = "user"
    permissions = "rwx"
  }


  properties = {
    hello = "aGVsbG8="
  }
}
