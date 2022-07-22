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

  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}

resource "azurerm_api_management_api_operation_policy" "policy" {
  api_name            = var.api_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  operation_id = var.operation_id
  xml_content  = file(var.policy_location)
}
