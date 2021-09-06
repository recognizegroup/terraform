terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.70.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_function_app" "function_app" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.asp_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  version                    = var.runtime_version

  app_settings = var.app_settings

  site_config {
    always_on = var.always_on
  }

  dynamic connection_string {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
  
  identity {
    type = "SystemAssigned"
  }
}
