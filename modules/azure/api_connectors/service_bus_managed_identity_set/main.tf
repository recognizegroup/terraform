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

resource "azurerm_resource_group_template_deployment" "service_bus_managed_identity" {
  for_each = var.connection_names

  name                = "${each.value}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "service_bus_connection_name" = {
      value = each.value
    }
    "service_bus_namespace_endpoint" = {
      value = var.service_bus_namespace_endpoint
    }
    "location" = {
      value = var.location
    }
  })
  deployment_mode = "Incremental"
}
