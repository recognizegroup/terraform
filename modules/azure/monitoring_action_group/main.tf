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
    for_each = var.email_receivers
    content {
      name                    = "Email ${email_receiver.value}"
      email_address           = email_receiver.value
      use_common_alert_schema = var.use_common_alert_schema
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.webhook_uris
    content {
      name                    = "Webhook ${webhook_receiver.value}"
      service_uri             = webhook_receiver.value
      use_common_alert_schema = var.use_common_alert_schema
    }
  }
}
