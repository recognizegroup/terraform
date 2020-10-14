terraform {
  required_version = ">=0.13.3"

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
  skip_provider_registration = var.skip_provider_registration
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks_workspace.id
}

data "azurerm_client_config" "current" {
}

resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = var.databricks_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_sku
}

resource "databricks_cluster" "shared_autoscaling_databricks_cluster" {
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
}
