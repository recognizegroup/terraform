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

  dynamic "advanced_filter" {
    for_each = var.advanced_filter

    content {
      dynamic "string_begins_with" {
        for_each = advanced_filter.value.string_begins_with == null ? [] : [1]

        content {
          key    = advanced_filter.value.string_begins_with.key
          values = advanced_filter.value.string_begins_with.values
        }
      }

      dynamic "string_ends_with" {
        for_each = advanced_filter.value.string_ends_with == null ? [] : [1]

        content {
          key    = advanced_filter.value.string_ends_with.key
          values = advanced_filter.value.string_ends_with.values
        }
      }
    }
  }

  included_event_types = var.event_types
  dynamic "delivery_property" {
    for_each = var.delivery_properties

    content {
      header_name  = delivery_property.value.header_name
      type         = delivery_property.value.property_type
      value        = title(delivery_property.value.property_type) == "Static" ? delivery_property.value.property_value : null
      source_field = title(delivery_property.value.property_type) == "Dynamic" ? delivery_property.value.source_field : null
    }
  }
}
