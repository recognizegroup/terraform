terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_api_management_group" "group" {
  for_each = {
    for index, group in var.groups : index => group
  }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  display_name        = each.value.display_name
  description         = each.value.description
  external_id         = each.value.external_id
  type                = each.value.type
}
