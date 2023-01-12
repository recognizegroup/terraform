terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_servicebus_namespace" "service_bus" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

resource "azurerm_servicebus_namespace_authorization_rule" "authorization_rule" {
  count        = var.authorization_rule == null ? 0 : 1
  name         = "${var.name}-authorization-rule"
  namespace_id = azurerm_servicebus_namespace.service_bus.id

  listen = var.authorization_rule.listen
  send   = var.authorization_rule.send
  manage = var.authorization_rule.manage
}
