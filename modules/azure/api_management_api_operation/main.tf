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
  openapi_data = yamldecode(file(var.openapi_file_path))

  all_operations = flatten([
    for path, methods in local.openapi_data["paths"] : [
      for method, details in methods : {
        path        = path
        method      = method
        summary     = details.summary
        operationId = details.operationId
        description = details.description
        content_type = try(keys(details.requestBody.content), [""])[0]
        responses   = { for code, response in details.responses : code => response.description }
      }
    ]
  ])

  operations_map = { for op in local.all_operations : "${op.path}:${op.method}" => op }
}

resource "azurerm_api_management_api_operation" "operation" {
  for_each = local.operations_map

  operation_id        = each.value.operationId
  api_name            = var.api_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  display_name        = each.value.summary
  method              = each.value.method
  url_template        = each.value.path
  description         = each.value.description

  dynamic "response" {
    for_each = each.value.responses

    content {
      status_code  = response.key
      description = response.value
    }
  }

  dynamic "request" {
    for_each = each.value.content_type != "" ? tolist([each.value.content_type]) : []

    content {
      representation {
        content_type = request.value
      }
    }
  }
}


