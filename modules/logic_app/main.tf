terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.68.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_logic_app_workflow" "logic_app" {
  name                               = var.name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  integration_service_environment_id = var.ise_id
}

// Deploy the ARM template workflow
resource "azurerm_resource_group_template_deployment" "logic_app_workflow_deployment" {
  depends_on = [
    azurerm_logic_app_workflow.logic_app]

  name = "${var.name}-deployment"
  resource_group_name = var.resource_group_name
  deployment_mode = "Incremental"
  parameters_content = var.parameters_content
  template_content  = var.arm_template
}


