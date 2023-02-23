terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = var.name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name
  enabled             = var.enabled

  dynamic "email_receiver" {
    for_each = var.email_receiver == null ? [] : [1]
    content {
      name                    = "Email"
      email_address           = var.email_receiver
      use_common_alert_schema = var.use_common_alert_schema
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.webhook_uri == null ? [] : [1]
    content {
      name                    = "Webhook"
      service_uri             = var.webhook_uri
      use_common_alert_schema = var.use_common_alert_schema
    }
  }
}
