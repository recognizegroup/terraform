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

resource "azurerm_api_management_group" "group" {
  // FIXME: Deze folder heeft geen `variables.tf` dus `var.groups` bestaat helemaal niet
  for_each = {
    for index, group in var.groups : index => group
  }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.api_management.name
  display_name        = each.value.display_name
  description         = each.value.description
  external_id         = each.value.external_id
  type                = each.value.type
}
