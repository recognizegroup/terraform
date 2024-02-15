terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. If 3.89 is released, we can upgrade to that
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  role_assignments = flatten([
    for principal_key, principal_id in var.principals :
    [
      for role in var.roles : {
        scope                = role.scope
        role_definition_name = role.role_name
        principal_id         = principal_id
        role_name            = role.name
      }
    ]
  ])
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each = { for ra in local.role_assignments :
  "${ra.principal_id}_${ra.role_definition_name}${ra.role_name != null ? "_${ra.role_name}" : ""}" => ra }

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
