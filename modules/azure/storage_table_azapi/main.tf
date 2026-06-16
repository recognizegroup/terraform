terraform {
  required_version = "~> 1.12"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.15"
    }
  }

  backend "azurerm" {}
}

provider "azapi" {}

# Entra ID (Azure AD) native equivalent of the azurerm_storage_table module.
# Manages the table via the ARM control plane (Microsoft.Storage), so it does
# NOT require Shared Key / data-plane access and keeps working when the storage
# account has shared_access_key_enabled = false.
resource "azapi_resource" "storage_table" {
  type      = "Microsoft.Storage/storageAccounts/tableServices/tables@2023-01-01"
  name      = var.storage_table_name
  parent_id = "${var.storage_account_id}/tableServices/default"
  body      = jsonencode({})
}
