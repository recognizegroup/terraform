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
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks.id
}

data "azurerm_client_config" "current" {
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = var.databricks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_sku
}

resource "databricks_cluster" "shared_autoscaling_databricks_cluster" {
  cluster_name            = "Shared Autoscaling Databricks Cluster"
  node_type_id            = "Standard_DS3_v2"
  spark_version           = "7.2.x-scala2.12"
  
  autoscale {
      min_workers = var.autoscaling_cluster_min_workers
      max_workers = var.autoscaling_cluster_max_workers
  } 
  
  spark_env_vars = {
    }
  init_scripts {
  }
} 
