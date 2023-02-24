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

resource "azurerm_resource_group_template_deployment" "key_vault_managed_identity" {
  name                = "${var.connection_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "keyvault_connection_name" = {
      value = var.connection_name
    }
    "key_vault_name" = {
      value = var.keyvault_name
    }
  })
  deployment_mode = "Incremental"
}
