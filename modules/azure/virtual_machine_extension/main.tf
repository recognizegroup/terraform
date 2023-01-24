terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_machine_extension" "vm_extension" {
  count = var.command_to_execute == null ? 0 : 1

  name                 = var.name
  virtual_machine_id   = var.virtual_machine_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "${var.command_to_execute}",
      "storageAccountName": "${var.storage_account_name}",
      "storageAccountKey": "${var.storage_account_key}",
      "fileUris": [
        "${join("\",\"", var.list_of_file_uris)}"]
    }
  PROTECTED_SETTINGS
}
