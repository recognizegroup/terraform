terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}


######################################################
#############        API schema        #############
######################################################

resource "azurerm_api_management_global_schema" "schema" {
  schema_id           = var.schema_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  type                = var.type
  value               = file(var.file_location)
}
