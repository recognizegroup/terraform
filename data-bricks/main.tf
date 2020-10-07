terraform {
  required_version = ">= 0.13.3"

  required_providers {
        azurerm     = ">=2.24.0"
        databricks  = {
          source = "databrickslabs/databricks"
          version = ">= 0.2.7"
        }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = var.skip_provider_registration
  features {}
}

provider "databricks" {
  host  = azurerm_databricks_workspace.databricks.workspace_url
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = var.databricks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_namespace_sku
}

resource "databricks_cluster" "shared_autoscaling_databricks_cluster" {
  cluster_name            = "Shared Autoscaling Databricks Cluster"
  node_type_id            = "Standard_DS3_v2"
  spark_version           = "7.3.x-scala2.12"
  
  autoscale {
      min_workers = 1
      max_workers = 2
  }
    
  library {
      maven {
      coordinates = "com.amazon.deequ:deequ:1.0.4"
      }
  }

  spark_env_vars = {
    PYSPARK_PYTHON = "/databricks/python3/bin/python3"
  }

  init_scripts {
  }
} 
