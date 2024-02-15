terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. If 3.89 is released, we can upgrade to that
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
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
