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

resource "azurerm_role_definition" "role_definition" {
  for_each = var.azure_groups
  name     = each.value.role
  scope    = data.azurerm_resource_group.resource_group.id

  permissions {
    data_actions = each.value.data_actions
    actions      = each.value.actions
  }

  assignable_scopes = [
    data.azurerm_resource_group.resource_group.id
  ]
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each           = var.azure_groups
  scope              = data.azurerm_resource_group.resource_group.id
  role_definition_id = lookup(azurerm_role_definition.role_definition[each.key], "role_definition_resource_id")
  principal_id       = lookup(var.azure_groups[each.key], "object_id")
}
