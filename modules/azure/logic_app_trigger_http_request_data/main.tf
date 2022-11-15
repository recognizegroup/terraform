terraform {
  required_version = ">=1.1.2"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.0.0"
    }
    azurerm = "=3.10.0"
  }

  backend "azurerm" {}
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}

// See also: https://github.com/hashicorp/terraform-provider-azurerm/issues/18866
data "azapi_resource_action" "logicapp_callbackurl" {
  resource_id            = "${var.logic_app_id}/triggers/${var.trigger_name}"
  action                 = "listCallbackUrl"
  type                   = "Microsoft.Logic/workflows/triggers@2018-07-01-preview"
  response_export_values = ["value"]
}
