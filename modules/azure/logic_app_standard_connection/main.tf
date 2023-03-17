terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.3.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  v1 = var.kind == "V1"
}

resource "azurerm_api_connection" "connection_v1" {
  count = local.v1 ? 1 : 0

  name                = var.connection_name
  resource_group_name = var.resource_group_name
  managed_api_id      = var.managed_api_id

  parameter_values = var.parameter_values

  # Ignore changes as these are secure values and therefore not returned
  lifecycle {
    ignore_changes = [parameter_values]
  }
}

resource "azurerm_resource_group_template_deployment" "connection_v2" {
  count = local.v1 ? 0 : 1

  name                = "${var.connection_name}-deployment"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content    = file("${path.module}/v2_deployment.json")
  parameters_content = jsonencode({
    connection_name = { value = var.connection_name }
    api_id          = { value = var.managed_api_id }
    parameters      = { value = var.parameter_values }
  })
}
