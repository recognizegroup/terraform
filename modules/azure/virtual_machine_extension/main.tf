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
