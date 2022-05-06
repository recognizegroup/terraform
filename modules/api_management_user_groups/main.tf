terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = "=3.4.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
    user_groups = flatten([
    for value in var.users_per_group : [
      for pair in setproduct([value.group_name], value.user_ids) : {
      group_name = pair[0]
      user_id    = pair[1]
    }
  ]])
}

resource "azurerm_api_management_group" "management_group" {
    for_each            = var.groups
    name                = each.value.name
    location            = var.location
    resource_group_name = var.resource_group_name
    api_management_name = var.api_management_name
    display_name        = each.value.display_name
    description         = each.value.description
}

resource "azurerm_api_mangagement_user" "management_user" {
    for_each            = var.users
    user_id             = each.value.user_id
    api_management_name = var.api_management_name
    resource_group_name = var.resource_group_name
    first_name          = each.value.first_name
    last_name           = each.value.last_name
    email               = each.value.email
}

resource "azurerm_api_management_group_user" "group_user" {
    for_each            = {for k, v in local.user_groups : k => v}
    user_id             = each.value.user_id
    group_name          = each.value.group_name
    resource_group_name = var.resource_group_name
    api_management_name = var.api_management_group_name
}