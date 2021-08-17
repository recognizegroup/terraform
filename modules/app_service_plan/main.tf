terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.72.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_app_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan_kind
  reserved            = var.app_service_plan_kind == "Linux" ? true : false

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }

}
