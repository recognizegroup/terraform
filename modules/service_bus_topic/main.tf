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

resource "azurerm_servicebus_topic" "service_bus_topic" {
  name                          = var.name
  namespace_id                  = var.namespace_id

  default_message_ttl           = var.default_message_ttl
  max_size_in_megabytes         = var.max_size_in_megabytes
  enable_partitioning           = var.enable_partitioning
  requires_duplicate_detection  = var.requires_duplicate_detection
}
