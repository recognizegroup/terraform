terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group_template_deployment" "log_analytics" {
  name                = "${var.connector_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "connector_name" = {
      value = var.connector_name
    },
    "function_url" = {
      value = var.function_url
    },
    "swagger" = {
      value = jsondecode(file(var.swagger))
    }
  })
  deployment_mode = "Incremental"
}
