terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  # Use Entra ID (Azure AD) for the Storage data plane instead of Shared Key.
  # Required when the target storage account has shared_access_key_enabled = false.
  storage_use_azuread = var.storage_use_azuread
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_name  = var.storage_account_name
  container_access_type = var.storage_container_access_type
}
