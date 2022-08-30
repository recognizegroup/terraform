terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = "=3.10.0"
  }

  backend "azurerm" {}

  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each = {
    for role in var.roles :
    "${role.object_id}_${role.role_name}${role.name != null ? "_${role.name}" : ""}" => role
  }

  scope                = each.value.scope
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}
