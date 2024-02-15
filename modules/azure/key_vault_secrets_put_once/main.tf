terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. If 3.89 is released, we can upgrade to that
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
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
  name            = each.value.secret_name
  value           = each.value.secret_value
  key_vault_id    = var.key_vault_id
  expiration_date = each.value.expiration_date

  lifecycle {
    ignore_changes = [value]
  }
}
