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

resource "azurerm_resource_group_template_deployment" "event_hub_managed_identity" {
  name                = "${var.connection_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "event_hub_connection_name" = {
      value = var.connection_name
    }
    "event_hub_namespace_endpoint" = {
      value = var.event_hub_namespace_endpoint
    }
    "location" = {
      value = var.location
    }
  })
  deployment_mode = "Incremental"
}
