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

resource "azurerm_api_management_api_operation_policy" "policy" {
  api_name            = var.api_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  operation_id = var.operation_id
  xml_content  = var.policy.file_location != null ? file(var.policy.file_location) : var.policy.xml_string
}
