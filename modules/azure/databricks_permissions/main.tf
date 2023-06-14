terraform {
  required_version = "~> 1.3"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "databricks" {
  host = var.workspace_url
}

locals {
  users = toset(flatten([
    for group in var.groups :
    group.users
  ]))
  members = flatten([
    for key, group in var.groups : [
      for user in group.users : {
        hash       = base64sha256("${group.display_name}/${user}")
        group_key  = key
        group_name = group.display_name
        user_name  = user
      }
    ]
  ])
}

resource "databricks_group" "group" {
  for_each     = var.groups
  display_name = each.value.display_name
}

resource "databricks_user" "user" {
  for_each = {
    for user in local.users :
    user => user
  }
  user_name    = each.key
  display_name = each.key
  force        = true
}

resource "databricks_group_member" "member" {
  for_each = {
    for member in local.members :
    member.hash => member
  }
  group_id  = databricks_group.group[each.value.group_key].id
  member_id = databricks_user.user[each.value.user_name].id

  depends_on = [
    databricks_group.group
  ]
}

resource "databricks_permissions" "cluster_usage" {
  cluster_id = var.cluster_id

  dynamic "access_control" {
    for_each = var.groups
    content {
      group_name       = access_control.value.display_name
      permission_level = access_control.value.cluster_usage
    }
  }

  depends_on = [
    databricks_group.group
  ]
}

// HACK: Initial tokens needs to be present for token usage permissions to be set
resource "databricks_token" "token" {
  comment          = "Initial token"
  lifetime_seconds = 8640000
}

resource "databricks_permissions" "token_usage" {
  authorization = "tokens"

  dynamic "access_control" {
    for_each = var.groups
    content {
      group_name       = access_control.value.display_name
      permission_level = access_control.value.token_usage
    }
  }

  depends_on = [
    databricks_group.group,
    databricks_token.token
  ]
}

resource "databricks_cluster_policy" "fair_use" {
  name       = "DBU cluster policy"
  definition = var.default_policy
}

resource "databricks_permissions" "can_use_cluster_policy_instance_profile" {
  cluster_policy_id = databricks_cluster_policy.fair_use.id

  dynamic "access_control" {
    for_each = var.groups
    content {
      group_name       = access_control.value.display_name
      permission_level = access_control.value.policy_usage
    }
  }

  depends_on = [
    databricks_group.group
  ]
}
