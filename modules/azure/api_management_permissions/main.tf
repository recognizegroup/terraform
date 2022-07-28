terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = "=2.82.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_api_management_group" "group" {
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
