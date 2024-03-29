terraform {
  required_version = "~> 1.3"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }

  backend "azurerm" {}
}

provider "databricks" {
  host = var.workspace_url
}

resource "databricks_user" "user" {
  for_each     = toset(var.users)
  user_name    = each.key
  display_name = each.key
  force        = true
}

data "databricks_group" "admins" {
  display_name = "admins"
}

resource "databricks_group_member" "admins" {
  for_each  = toset(var.admins)
  group_id  = data.databricks_group.admins.id
  member_id = databricks_user.user[each.value].id
}

// HACK: Initial tokens needs to be present for token usage permissions to be set
resource "databricks_token" "token" {
  comment          = "Initial token"
  lifetime_seconds = 8640000
}

resource "databricks_permissions" "token_usage" {
  authorization = "tokens"

  access_control {
    group_name       = "users"
    permission_level = "CAN_USE"
  }

  depends_on = [
    databricks_token.token
  ]
}
