terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=2.96.0"
  }

  backend "azurerm" {}

  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]

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

  dynamic "subject_filter" {
    for_each = var.subject_filter == null ? [] : [1]

    content {
      subject_begins_with = var.subject_filter.subject_begins_with
      subject_ends_with   = var.subject_filter.subject_ends_with
      case_sensitive      = var.subject_filter.case_sensitive
    }
  }
  included_event_types = var.event_types
}
