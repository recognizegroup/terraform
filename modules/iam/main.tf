terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = "=3.10.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "resource_group" {
  count = var.scope == null ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each = {
    for role in var.roles :
    "${role.object_id}_${role.role_name}" => role
  }
  scope                = var.scope != null ? var.scope : data.azurerm_resource_group.resource_group[0].id
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}
