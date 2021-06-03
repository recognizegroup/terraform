terraform {
  required_version = ">=0.14.0"

  required_providers {
    azurerm = "=2.37.0"
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
