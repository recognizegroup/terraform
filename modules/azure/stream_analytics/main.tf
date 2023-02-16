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
  transformation_query                     = var.stream_query == null ? "SELECT * INTO [${local.blob_outputs[0].name}] FROM [${local.eventhub_inputs[0].name}]" : var.stream_query
}

resource "azurerm_stream_analytics_stream_input_eventhub" "eventhub_stream_input" {
  for_each                     = local.eventhub_inputs
  name                         = each.value.name
  stream_analytics_job_name    = azurerm_stream_analytics_job.job.name
  resource_group_name          = var.resource_group_name
  eventhub_consumer_group_name = each.value.eventhub_consumer_group_name
  eventhub_name                = each.value.eventhub_name
  servicebus_namespace         = each.value.eventhub_namespace_name
  shared_access_policy_key     = data.azurerm_eventhub_namespace.namespaces[each.key].default_primary_key
  shared_access_policy_name    = each.value.eventhub_access_policy_name

  serialization {
    type     = each.value.serialization.type
    encoding = each.value.serialization.encoding
  }
}

/*
  The following block is a bit of a hack.
  
  azurerm v3.3.0 has no compression settings for the
  "azurerm_stream_analytics_stream_input_eventhub" module. 
  We work around this by directly invoking an Azure CLI 
  update command.

  This command has been wrapped in a bash script for
  best execution compatibility. However Terraform/Terragrunt
  commands will have to be run from a bash-capable shell.
  */
resource "null_resource" "eventhub_compression" {
  for_each   = local.eventhub_inputs
  depends_on = [azurerm_stream_analytics_stream_input_eventhub.eventhub_stream_input]

  triggers = {
    "compression_type" = each.value.compression_type
  }

  provisioner "local-exec" {
    command = "sh set_compression_type.sh -g ${var.resource_group_name} -j ${azurerm_stream_analytics_job.job.name} -i ${each.value.name} -c ${each.value.compression_type}"
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
