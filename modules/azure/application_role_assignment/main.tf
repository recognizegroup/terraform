terraform {
  required_version = "~> 1.3"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.36"
    }
  }
}

provider "azuread" {}

resource "azuread_service_principal" "internal" {
  client_id    = var.application_id
  use_existing = var.use_existing_service_principal
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
