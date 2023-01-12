terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group_template_deployment" "log_analytics" {
  name                = "${var.connection_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "connection_name" = {
      value = var.connection_name
    }
    "log_analytics_workspace_id" = {
      value = var.log_analytics_workspace_id
    }
    "log_analytics_workspace_key" = {
      value = var.log_analytics_workspace_key
    }
  })
  deployment_mode = "Incremental"
}
