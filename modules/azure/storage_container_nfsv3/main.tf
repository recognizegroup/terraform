terraform {
  required_version = ">=1.3.0"

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

resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  name               = var.storage_container_name
  storage_account_id = var.storage_account_id

  dynamic "ace" {
    for_each = var.ace_permissions
    iterator = item
    content {
      scope       = item.value.scope
      type        = item.value.type
      permissions = item.value.permissions
    }
  }
}

resource "azurerm_storage_data_lake_gen2_path" "directory" {
  count = var.directories == null ? 0 : length(var.directories)

  path               = var.directories[count.index]
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.filesystem.name
  storage_account_id = var.storage_account_id
  resource           = "directory"
}
