terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.15"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

resource "azurerm_monitor_data_collection_rule" "workspace_transformations" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "WorkspaceTransforms"
  description         = var.description
  tags                = var.tags

  destinations {
    log_analytics {
      name                  = var.destination_name
      workspace_resource_id = var.log_analytics_workspace_id
    }
  }

  dynamic "data_flow" {
    for_each = var.transformations

    content {
      streams       = ["Microsoft-Table-${data_flow.key}"]
      destinations  = [var.destination_name]
      transform_kql = data_flow.value
    }
  }
}

resource "azapi_update_resource" "workspace_default_data_collection_rule" {
  type        = "Microsoft.OperationalInsights/workspaces@2022-10-01"
  resource_id = var.log_analytics_workspace_id

  body = jsonencode({
    properties = {
      defaultDataCollectionRuleResourceId = azurerm_monitor_data_collection_rule.workspace_transformations.id
    }
  })
}
