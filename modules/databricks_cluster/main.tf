terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = ">=2.52.0"
    databricks = {
      source  = "databrickslabs/databricks"
      version = ">=0.3.5"
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

locals {
  users = toset(flatten([
    for group in var.databricks_groups :
    group.users
  ]))
  members = flatten([
    for key, group in var.databricks_groups : [
      for user in group.users : {
        hash       = base64sha256("${group.display_name}/${user}")
        group_key  = key
        group_name = group.display_name
        user_name  = user
      }
    ]
  ])
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = var.databricks_cluster_name
  node_type_id            = var.databricks_cluster_node_type
  spark_version           = var.databricks_cluster_spark_version
  autotermination_minutes = var.databricks_cluster_auto_termination

  autoscale {
    min_workers = var.autoscaling_cluster_min_workers
    max_workers = var.autoscaling_cluster_max_workers
  }

  spark_env_vars = {
    PYSPARK_PYTHON = var.databricks_cluster_python_location
  }

  dynamic "library" {
    for_each = toset(var.databricks_cluster_packages)
    content {
      pypi {
        package = library.key
      }
    }
  }

  spark_conf = var.databricks_spark_conf
}

resource "databricks_global_init_script" "init1" {
  count   = var.databricks_init_script == "" ? 0 : 1
  source  = "init.sh"
  name    = "init script"
  enabled = true
}

resource "databricks_group" "group" {
  for_each     = var.databricks_groups
  display_name = each.value.display_name
}

resource "databricks_user" "user" {
  for_each = {
    for user in local.users :
    user => user
  }
  user_name = each.key
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
  count      = var.databricks_sku == "premium" ? 1 : 0
  cluster_id = databricks_cluster.shared_autoscaling.cluster_id

  dynamic "access_control" {
    for_each = var.databricks_sku == "premium" ? var.databricks_groups : {}
    content {
      group_name       = access_control.value.display_name
      permission_level = access_control.value.cluster_usage
    }
  }

  depends_on = [
    databricks_group.group
  ]
}

resource "databricks_permissions" "token_usage" {
  count         = var.databricks_sku == "premium" ? 1 : 0
  authorization = "tokens"

  dynamic "access_control" {
    for_each = var.databricks_sku == "premium" ? var.databricks_groups : {}
    content {
      group_name       = access_control.value.display_name
      permission_level = access_control.value.token_usage
    }
  }

  depends_on = [
    databricks_group.group
  ]
}
