terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
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
