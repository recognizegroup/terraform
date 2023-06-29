terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_eventgrid_system_topic" "topic" {
  name                   = var.topic_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  source_arm_resource_id = var.source_arm_resource_id
  topic_type             = var.topic_type
}
