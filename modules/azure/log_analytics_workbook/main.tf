terraform {
  required_version = ">=1.1.2"

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

locals {
  # // Remove need for specifying the "value" field for every parameter
  # parameters_content = {
  #   for key, value in var.arm_parameters :
  #   key => { "value" = value }
  # }
}

// Deploy workbook as ARM template conditional when arm_template_path is specified
// To export the ARM template from the Azure portal go to Log Analytics workspaces > Automation > Export Template
# resource "azurerm_resource_group_template_deployment" "workflow_deployment" {
#   count               = var.arm_template_path == null ? 0 : 1
#   name                = "${var.workbook_name}-deployment"
#   resource_group_name = var.resource_group_name
#   deployment_mode     = "Incremental"
#   template_content    = file(var.arm_template_path)
#   parameters_content  = jsonencode(local.parameters_content)
# }

resource "random_uuid" "test" {
}



resource "azurerm_resource_group_template_deployment" "key_vault_managed_identity" {
  name                = "${var.workbook_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./test.json")
  parameters_content = jsonencode({
    "workbook_name" = {
      value = var.workbook_name
    }

    "workbookId" = {
      value = random_uuid.test.result
    }

    "serializedData" = {
      value = jsondecode(file(var.serializedDataFile))
    }

    "sourceId" = {
      value = var.resource_id_with_data 
    }
    # "key_vault_name" = {
    #   value = var.keyvault_name
    # }
  })
  deployment_mode = "Incremental"
}
