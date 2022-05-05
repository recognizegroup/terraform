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
  user_subs = user_subscriptions
      
}

resource "azurerm_api_management_subscription" "subscription" {
  for_each = locals.user_subs
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  user_id             = each.value.user_id
  product_id          = each.value.product_ids
  display_name        = each.value.name
}
