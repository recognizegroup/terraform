terraform {
  required_version = ">=0.13.3"

  required_providers {
    azurerm = "=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  eventhub_inputs = { for eventhub_input in var.eventhub_inputs : eventhub_input.name => eventhub_input }
  blob_outputs    = { for blob_output in var.blob_outputs : blob_output.name => blob_output }
}

data "azurerm_eventhub_namespace" "namespaces" {
  for_each            = local.eventhub_inputs
  name                = each.value.eventhub_namespace_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_stream_analytics_job" "job" {
  name                                     = var.name
  resource_group_name                      = var.resource_group_name
  location                                 = var.location
  compatibility_level                      = var.stream_compatibility_level
  data_locale                              = var.stream_data_locale
  events_late_arrival_max_delay_in_seconds = var.stream_late_arrival_delay
  events_out_of_order_max_delay_in_seconds = var.stream_out_of_order_delay
  events_out_of_order_policy               = var.stream_out_of_order_policy
  output_error_policy                      = var.stream_error_policy
  streaming_units                          = var.stream_streaming_units
  transformation_query                     = var.stream_query
}

resource "azurerm_stream_analytics_stream_input_eventhub" "stream_input" {
  for_each                     = local.eventhub_inputs
  name                         = each.value.name
  stream_analytics_job_name    = azurerm_stream_analytics_job.job.name
  resource_group_name          = var.resource_group_name
  eventhub_consumer_group_name = each.value.eventhub_consumer_group_name
  eventhub_name                = each.value.eventhub_name
  servicebus_namespace         = each.value.eventhub_namespace_name
  shared_access_policy_key     = data.azurerm_eventhub_namespace.namespaces[each.key].default_primary_key // TODO
  shared_access_policy_name    = each.value.eventhub_access_policy_name

  serialization {
    type     = each.value.serialization.type
    encoding = each.value.serialization.encoding
  }
}

resource "azurerm_stream_analytics_output_blob" "stream_output" {
  for_each                  = local.blob_outputs
  name                      = each.value.name
  stream_analytics_job_name = azurerm_stream_analytics_job.job.name
  resource_group_name       = var.resource_group_name
  storage_account_name      = each.value.storage_account_name
  storage_account_key       = each.value.storage_account_connection_string
  storage_container_name    = each.value.storage_container_name
  path_pattern              = each.value.path_pattern
  date_format               = each.value.date_format
  time_format               = each.value.time_format

  serialization {
    type     = each.value.serialization.type
    encoding = each.value.serialization.encoding
    format   = each.value.serialization.format
  }
}
