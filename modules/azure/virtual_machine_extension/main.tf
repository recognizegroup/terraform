terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = "=2.82.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_machine_extension" "example" {
  name                 = "hostname"
  virtual_machine_id   =  var.virtual_machine_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

   protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -File ./fileShare.ps1 -ExecutionPolicy Bypass -fileShareName 4ps-payment-files -storageAccountName stvwtipp2pdev -storageAccountKeys uipLRpBvYH+COWFiWGU6uznjjIGjLiZVa8TmdJQGIzT0mC2GZdFOlHB3eeNSyo4krlIrEv98C6jq+AStNnWSGQ==",
      "storageAccountName": "stvwtipp2pdev",
      "storageAccountKey": "uipLRpBvYH+COWFiWGU6uznjjIGjLiZVa8TmdJQGIzT0mC2GZdFOlHB3eeNSyo4krlIrEv98C6jq+AStNnWSGQ==",
      "fileUris": [${ join(",",var.list_of_file_uris)}]
    }
  PROTECTED_SETTINGS
}