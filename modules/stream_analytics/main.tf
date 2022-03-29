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
  stream_output_name = "${var.name}-output"
  stream_input_name  = "${var.name}-input"
  stream_job_name    = "${var.name}-job"

  select_all_query = "SELECT * INTO \"${local.stream_output_name}\" FROM \"${local.stream_input_name}\""
}

data "azurerm_eventhub_namespace" "namespace" {
  name                = var.eventhub_namespace_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_stream_analytics_job" "job" {
  name                                     = local.stream_job_name
  resource_group_name                      = var.resource_group_name
  location                                 = var.location
  compatibility_level                      = var.stream_compatibility_level
  data_locale                              = var.stream_data_locale
  events_late_arrival_max_delay_in_seconds = var.stream_late_arrival_delay
  events_out_of_order_max_delay_in_seconds = var.stream_out_of_order_delay
  events_out_of_order_policy               = var.stream_out_of_order_policy
  output_error_policy                      = var.stream_error_policy
  streaming_units                          = var.stream_streaming_units
  transformation_query                     = var.stream_query == null ? local.select_all_query : var.stream_query
}

resource "azurerm_stream_analytics_stream_input_eventhub" "stream_input" {
  name                         = local.stream_input_name
  stream_analytics_job_name    = azurerm_stream_analytics_job.job.name
  resource_group_name          = var.resource_group_name
  eventhub_consumer_group_name = var.eventhub_consumer_group_name
  eventhub_name                = var.eventhub_name
  servicebus_namespace         = var.eventhub_namespace_name
  shared_access_policy_key     = data.azurerm_eventhub_namespace.namespace.default_primary_key
  shared_access_policy_name    = var.eventhub_access_policy_name

  serialization {
    type     = var.serialization_type
    encoding = var.serialization_name
  }
}

resource "azurerm_stream_analytics_output_blob" "stream_output" {
  name                      = local.stream_output_name
  stream_analytics_job_name = azurerm_stream_analytics_job.job.name
  resource_group_name       = var.resource_group_name
  storage_account_name      = var.storage_account_name
  storage_account_key       = var.storage_connection_string
  storage_container_name    = var.storage_container_name
  path_pattern              = var.stream_output_path_pattern
  date_format               = var.stream_output_date_format
  time_format               = var.stream_output_time_format

  serialization {
    type     = var.serialization_type
    encoding = var.serialization_name
    format   = var.serialization_format
  }
}
