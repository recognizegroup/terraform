terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = ">=2.71.0"
    databricks = {
      source  = "databrickslabs/databricks"
      version = ">=0.3.7"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = var.databricks_workspace_id
}

resource "databricks_secret_scope" "scope" {
  for_each = toset(distinct([
    for secret in var.databricks_secrets :
    secret.secret_scope
  ]))
  name = each.key
}

data "azurerm_key_vault_secret" "secret" {
  for_each = {
    for secret in var.databricks_secrets :
    secret.secret_name => secret
  }
  name         = each.value.key_vault_secret_name
  key_vault_id = each.value.key_vault_id
}

resource "databricks_secret" "databricks_secret" {
  for_each = {
    for secret in var.databricks_secrets :
    secret.secret_name => secret
  }
  key          = each.value.secret_name
  string_value = data.azurerm_key_vault_secret.secret[each.key].value
  scope        = databricks_secret_scope.scope[each.value.secret_scope].id
}

resource "databricks_secret_acl" "acl" {
  for_each = {
    for index, permission in var.databricks_secret_permissions :
    index => permission
  }
  principal  = each.value.group_name
  permission = each.value.secret_permission
  scope      = databricks_secret_scope.scope[each.value.secret_scope].name
}
