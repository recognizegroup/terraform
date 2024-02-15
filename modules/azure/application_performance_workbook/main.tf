terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. If 3.89 is released, we can upgrade to that
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
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
