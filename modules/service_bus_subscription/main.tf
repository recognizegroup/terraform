terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=2.96.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_servicebus_subscription" "service_bus_subscription" {
  name                          = var.name
  topic_id                      = var.topic_id
  max_delivery_count            = var.max_delivery_count
}
