terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_servicebus_topic" "service_bus_topic" {
  name                                    = var.name
  namespace_id                            = var.namespace_id
  default_message_ttl                     = var.default_message_ttl
  max_size_in_megabytes                   = var.max_size_in_megabytes
  enable_partitioning                     = var.enable_partitioning
  requires_duplicate_detection            = var.requires_duplicate_detection
  duplicate_detection_history_time_window = var.duplicate_detection_history_time_window
  enable_batched_operations               = var.enable_batched_operations
  status                                  = var.status
  support_ordering                        = var.support_ordering
  auto_delete_on_idle                     = var.auto_delete_on_idle
  enable_express                          = var.enable_express
}
