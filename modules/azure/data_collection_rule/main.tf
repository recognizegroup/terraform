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

locals {
  streams = { for stream in var.streams : stream.name => stream }
}

resource "azurerm_monitor_data_collection_rule" "data_collection_rule" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  data_collection_endpoint_id = var.data_collection_endpoint_id
  description                 = var.description
  tags                        = var.tags

  destinations {
    log_analytics {
      name                  = var.destination_name
      workspace_resource_id = var.log_analytics_workspace_id
    }
  }

  dynamic "stream_declaration" {
    for_each = local.streams

    content {
      stream_name = stream_declaration.value.name

      dynamic "column" {
        for_each = stream_declaration.value.columns

        content {
          name = column.value.name
          type = column.value.type
        }
      }
    }
  }

  dynamic "data_flow" {
    for_each = local.streams

    content {
      streams       = [data_flow.value.name]
      destinations  = [var.destination_name]
      transform_kql = data_flow.value.transform_kql
      output_stream = data_flow.value.output_stream
    }
  }
}
