terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.81.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "azurerm_api_management" "api_management" {
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.api_management_sku

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_identity_provider_aad" "identity_provider_aad" {
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.api_management.name
  client_id           = var.client_id
  client_secret       = var.client_secret
  allowed_tenants     = var.id_provider_allowed_tenants
}
