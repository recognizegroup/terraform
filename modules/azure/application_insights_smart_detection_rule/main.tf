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

resource "azurerm_application_insights_smart_detection_rule" "application_insights_smart_detection_rule" {
  name                               = var.name
  application_insights_id            = var.application_insights_id
  enabled                            = var.enabled
  send_emails_to_subscription_owners = var.send_emails_to_subscription_owners
  additional_email_recipients        = var.additional_email_recipients
}
