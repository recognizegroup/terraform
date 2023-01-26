terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=3.25.0"
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group_template_deployment" "policy" {
  name                = "${var.connection_name}-ap"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content    = file("${path.module}/policy.json")
  parameters_content = jsonencode({
    connection_name = { value = var.connection_name }
    principal_id    = { value = var.principal_id }
  })
}
