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
  name                                      = var.name
  topic_id                                  = var.topic_id
  max_delivery_count                        = var.max_delivery_count
  lock_duration                             = var.lock_duration
  requires_session                          = var.requires_session
  default_message_ttl                       = var.default_message_ttl
  dead_lettering_on_message_expiration      = var.dead_lettering_on_message_expiration
  dead_lettering_on_filter_evaluation_error = var.dead_lettering_on_filter_evaluation_error
  enable_batched_operations                 = var.enable_batched_operations
  auto_delete_on_idle                       = var.auto_delete_on_idle
}
