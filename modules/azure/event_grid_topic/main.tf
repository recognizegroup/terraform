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

resource "azurerm_eventgrid_system_topic" "topic" {
  name                   = var.topic_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  source_arm_resource_id = var.source_arm_resource_id
  topic_type             = var.topic_type
}