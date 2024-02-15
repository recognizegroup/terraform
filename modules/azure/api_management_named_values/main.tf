terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_api_management_named_value" "named_value" {
  for_each            = { for named_value in var.named_values : named_value.name => named_value }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  display_name        = each.value.name
  value               = each.value.value
  secret              = each.value.key_vault_secret_id != null ? true : each.value.encrypt

  dynamic "value_from_key_vault" {
    for_each = each.value.key_vault_secret_id != null ? [1] : []

    content {
      secret_id = each.value.key_vault_secret_id
    }
  }
}
