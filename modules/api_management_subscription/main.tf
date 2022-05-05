terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = "=2.82.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  subscriptions = flatten([
    for user_key, value in var.products_per_user : [
      for product_key, pair in setproduct([value.user_id], value.product_ids) : {
      user_id    = pair[0].value
      product_id = pair[1].value
      name       = "apim-subcription-${user_key}${product_key.key}"
    }
  ]])
}

resource "azurerm_api_management_subscription" "subscription" {
  for_each = local.subscriptions
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  user_id             = each.value.user_id
  product_id          = each.value.product_id
  display_name        = each.value.name
}
