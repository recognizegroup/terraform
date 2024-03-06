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

resource "azurerm_api_management_api_operation" "operation" {
  operation_id        = var.operation_id
  api_name            = var.api_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  display_name        = var.display_name
  method              = var.operation_method
  url_template        = var.url_template
  description         = var.description

  response {
    status_code = 200
  }

  dynamic "request" {
    for_each = var.request_content_type != "" ? tolist([var.request_content_type]) : []

    content {
      representation {
        content_type = request.value
      }
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "policy" {
  depends_on = [
    azurerm_api_management_api_operation.operation
  ]
  api_name            = var.api_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  operation_id = var.operation_id
  xml_content  = var.policy.file_location != null ? file(var.policy.file_location) : var.policy.xml_string
}
