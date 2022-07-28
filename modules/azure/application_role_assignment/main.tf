terraform {
  required_version = ">=1.0.9"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.22.0"
    }
  }

  backend "azurerm" {}
}

provider "azuread" {}

resource "azuread_service_principal" "internal" {
  application_id = var.application_id
}

resource "azuread_app_role_assignment" "role_assignment" {
  for_each = {
    for assignment in var.assignments :
    "${assignment.role_id}_${assignment.object_id}" => assignment
  }
  app_role_id         = each.value.role_id
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.internal.object_id
}
