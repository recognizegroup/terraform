terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }
  }

  backend "azurerm" {}
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
