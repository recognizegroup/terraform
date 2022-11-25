terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
}



resource "azurerm_api_management_certificate" "apim_certificate" {
  name                = var.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  key_vault_secret_id = var.keyvault_certificate_id
}