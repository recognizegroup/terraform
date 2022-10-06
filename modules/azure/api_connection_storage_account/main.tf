terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.22.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group_template_deployment" "example" {
  name                = "${var.connection_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "connectionName" = {
      value = var.connection_name
    }
    "storage_account_name" = {
      value = var.storage_account_name
    }
    "storage_account_access_key" = {
      value = var.storage_account_access_key
    }
  })
  deployment_mode = "Incremental"
}
