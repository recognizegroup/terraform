terraform {
  required_version = "~> 1.3"

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

resource "azurerm_key_vault_secret" "secret" {
  for_each = {
    for index, secret in nonsensitive(var.secrets) :
    secret.secret_name => secret
  }
  name         = each.value.secret_name
  value        = each.value.secret_value
  key_vault_id = var.key_vault_id
}
