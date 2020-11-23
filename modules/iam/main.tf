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

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "subscription" {
}

data "azuread_group" "group" {
  for_each = var.azure_groups
  name     = each.value.name
}

resource "azurerm_role_definition" "role_definition" {
  for_each = var.azure_groups
  name     = each.value.role
  scope    = data.azurerm_subscription.subscription.id

  permissions {
    data_actions = each.value.data_actions
    actions      = each.value.actions
  }

  assignable_scopes = [
    data.azurerm_subscription.subscription.id
  ]
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each           = var.azure_groups
  scope              = data.azurerm_subscription.subscription.id
  role_definition_id = lookup(azurerm_role_definition.role_definition[each.key], "id")
  principal_id       = lookup(data.azuread_group.group[each.key], "id")
}
