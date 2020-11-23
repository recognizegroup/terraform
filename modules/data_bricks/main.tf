terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = ">=2.24.0"
    databricks = {
      source  = "databrickslabs/databricks"
      version = ">=0.2.7"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Databricks/workspaces/${var.databricks_workspace_name}"
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

data "azurerm_client_config" "current" {
}

resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = var.databricks_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_sku
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name  = var.databricks_cluster_name
  node_type_id  = var.databricks_cluster_node_type
  spark_version = var.databricks_cluster_spark_version

  autoscale {
    min_workers = var.autoscaling_cluster_min_workers
    max_workers = var.autoscaling_cluster_max_workers
  }

  spark_env_vars = {
    PYSPARK_PYTHON = var.databricks_cluster_python_location
  }

  library {
    pypi {
      package = var.databricks_cluster_packages
    }
  }

  depends_on = [
    azurerm_databricks_workspace.databricks_workspace
  ]
}

resource "databricks_group" "group" {
  for_each     = var.databricks_groups
  display_name = each.value.display_name

  depends_on = [
    azurerm_databricks_workspace.databricks_workspace
  ]
}

resource "databricks_user" "user" {
  for_each = {
    for user in local.users :
    user => user
  }
  user_name = each.key

  depends_on = [
    azurerm_databricks_workspace.databricks_workspace
  ]
}

resource "databricks_group_member" "member" {
  for_each = {
    for member in local.members :
    member.hash => member
  }
  group_id  = databricks_group.group[each.value.group_key].id
  member_id = databricks_user.user[each.value.user_name].id

  depends_on = [
    azurerm_databricks_workspace.databricks_workspace
  ]
}

resource "databricks_permissions" "cluster_usage" {
  count      = var.databricks_sku == "premium" ? 1 : 0
  cluster_id = databricks_cluster.shared_autoscaling.cluster_id

  dynamic "access_control" {
    for_each = var.databricks_sku == "premium" ? var.databricks_groups : {}
    content {
      group_name       = access_control.value.display_name
      permission_level = access_control.value.permission_level
    }
  }
}
