terraform {
  required_version = ">=1.1.7"

  // FIXME: Is hier wel azurerm nodig?
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }
    databricks = {
      // FIXME: source has moved to databricks/databricks
      source  = "databrickslabs/databricks"
      version = ">=0.5.4"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
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
