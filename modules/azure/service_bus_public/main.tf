terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
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
