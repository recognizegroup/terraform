terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = "=3.4.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_api_management_group" "group" {
    for_each            = {for k, v in var.groups : k => v}
    name                = each.value.name
    resource_group_name = var.resource_group_name
    api_management_name = var.api_management_name
    display_name        = each.value.display_name
    external_id         = each.value.external_id
}

