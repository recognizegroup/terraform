terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.41.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_app_service" "app_service" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  site_config {
    always_on                = true
    ftps_state               = "AllAllowed"
    dotnet_framework_version = var.dotnet_framework_version
    websockets_enabled       = var.websockets_enabled
    scm_type                 = "LocalGit"
  }

  app_settings = var.app_settings

  connection_string{
    name = var.connection_string_name
    type = "SQLAzure"
    value = var.connection_string_value
  }
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      site_config.0.scm_type,
      source_control.0.repo_url
    ]
  }
}

resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  for_each  = var.custom_domain

  hostname = each.value
  app_service_name    = azurerm_app_service.app_service.name
  resource_group_name = var.resource_group_name
}
