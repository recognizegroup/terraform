terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.37.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each = {
    for idx, role in var.roles :
    idx => role
  }
  scope                = data.azurerm_resource_group.resource_group.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}
