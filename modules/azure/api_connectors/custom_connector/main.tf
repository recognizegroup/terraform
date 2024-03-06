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

data "azurerm_subscription" "current" {
}

resource "azurerm_resource_group_template_deployment" "arm_managed_identity" {
  name                = "${var.connection_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "arm_connection_name" = {
      value = var.connection_name
    }
    "location" = {
      value = var.location
    },
    "connector_resource_group_name" = {
      value = var.connector_resource_group_name
    },
    "connector_name": {
      value = var.connector_name
    },
    "api_connector_id":{
      value = "${data.azurerm_subscription.current.id}/resourceGroups/${var.connector_resource_group_name}/providers/Microsoft.Web/customApis/${var.connector_name}"
    }
  })
  deployment_mode = "Incremental"
}

