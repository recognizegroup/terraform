terraform {
  required_version = ">=0.14.0"

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

data "azurerm_key_vault_secret" "secret" {
  name         = var.secret_name
  key_vault_id = var.key_vault_id
}
