terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

data "azurerm_key_vault_secret" "secret" {
  name         = var.secret_name
  key_vault_id = var.key_vault_id
}
