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

resource "azurerm_eventgrid_system_topic" "topic" {
  name                   = var.topic_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  source_arm_resource_id = var.storage_account_id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

resource "azurerm_eventgrid_system_topic_event_subscription" "subscription" {
  name                = var.subscription_name
  system_topic        = azurerm_eventgrid_system_topic.topic.name
  resource_group_name = var.resource_group_name

  webhook_endpoint {
    count = var.webhook_url == null ? 0 : 1
    url   = var.webhook_url
  }
}
