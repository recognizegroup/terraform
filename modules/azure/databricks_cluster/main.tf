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

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = var.cluster_name
  node_type_id            = var.node_type
  spark_version           = var.spark_version
  autotermination_minutes = var.auto_termination_minutes

  autoscale {
    min_workers = var.autoscaling_min_workers
    max_workers = var.autoscaling_max_workers
  }

  azure_attributes {
    availability       = "SPOT_WITH_FALLBACK_AZURE"
    first_on_demand    = 1
    spot_bid_max_price = -1
  }

  spark_env_vars = {
    PYSPARK_PYTHON = var.python_location
  }

  dynamic "library" {
    for_each = toset(var.python_packages)
    content {
      pypi {
        package = library.key
      }
    }
  }

  spark_conf = var.spark_conf
}

resource "databricks_global_init_script" "init_script" {
  count   = var.init_script == "" ? 0 : 1
  source  = var.init_script
  name    = "init script"
  enabled = true
}

resource "databricks_cluster_policy" "fair_use_policy" {
  name       = "Fair use cluster policy"
  definition = var.cluster_policy
}

resource "databricks_permissions" "fair_use_policy_usage" {
  cluster_policy_id = databricks_cluster_policy.fair_use_policy.id

  access_control {
    group_name       = "users"
    permission_level = "CAN_USE"
  }
}
