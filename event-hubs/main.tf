terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = ">=2.20.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  tenant_id                  = var.tenant_id
  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  skip_provider_registration = var.skip_provider_registration
  features {}
}

resource "azurerm_eventhub_namespace" "namespace" {
  name                = var.eventhub_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity
}

resource "azurerm_eventhub" "eventhub" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_authorization_rule" "rule" {
  name                = var.eventhub_rule_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}
