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

resource "azurerm_eventgrid_system_topic_event_subscription" "subscription" {
  name                = var.name
  system_topic        = var.system_topic_name
  resource_group_name = var.resource_group_name

  dynamic "webhook_endpoint" {
    for_each = var.webhook_url == null ? [] : [1]
    content {
      url = var.webhook_url
    }
  }

  service_bus_topic_endpoint_id = var.service_bus_topic_id
}
