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

locals {
  do_schema = var.schema.file_location != null && var.schema.type != null && var.schema.schema_id != null ? true : false
}

######################################################
#############        API schema        #############
######################################################

resource "azurerm_api_management_global_schema" "json" {
  count               = local.do_schema ? 1 : 0
  schema_id           = var.schema.schema_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  type                = var.schema.type
  value               = file(var.schema.file_location)
}
