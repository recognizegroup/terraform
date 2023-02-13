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

resource "random_uuid" "workbook_guid" {
}

resource "azurerm_resource_group_template_deployment" "log_analytics_workbook" {
  name                = "${var.workbook_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./workbook_arm.json")
  parameters_content = jsonencode({
    "workbookId" = {
      value = random_uuid.workbook_guid.result
    }

    "workbook_name" = {
      value = var.workbook_name
    }

    "serializedData" = {
      // Trick that allows to take any json file and Minimize it
      value = jsonencode(jsondecode(file(var.workbook_template)))
    }

    "sourceId" = {
      value = var.resource_id_with_data 
    }
  })
  deployment_mode = "Incremental"
}
