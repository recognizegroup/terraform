terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = "=2.98.0"
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
    for role in var.roles :
    "${role.object_id}_${role.role_name}" => role
  }
  scope                = data.azurerm_resource_group.resource_group.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}
