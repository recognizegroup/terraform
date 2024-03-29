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

resource "random_uuid" "workbook_guid" {
}

resource "azurerm_application_insights_workbook" "workbook" {
  name                = random_uuid.workbook_guid.result
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = var.name

  // Trick that allows to take any json file and Minimize it
  data_json = jsonencode(jsondecode(file("${path.module}/workbook.json")))
  source_id = lower(var.log_analytics_workspace_id)
}
