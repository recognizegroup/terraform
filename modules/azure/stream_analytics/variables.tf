variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "name" {
  type        = string
  description = "Name of the Azure Stream Analytics job."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "eventhub_inputs" {
  type = list(object({
    name                         = string,
    eventhub_name                = string,
    eventhub_namespace_name      = string,
    eventhub_consumer_group_name = string,
    eventhub_access_policy_name  = string, // Default: "RootManageSharedAccessKey"
    compression_type             = string, // Default: "None"

    serialization = object({
      type     = string, // Default: "Json"
      encoding = string  // Default: "UTF8"
    })
  }))
}

variable "blob_outputs" {
  type = list(object({
    name                              = string,
    storage_account_name              = string,
    storage_account_connection_string = string,
    storage_container_name            = string,
    path_pattern                      = string,
    date_format                       = string, // Default: "yyyy/MM/dd"
    time_format                       = string, // Default: "HH"

    serialization = object({
      type     = string, // Default: "Json"
      encoding = string, // Default: "UTF8"
      format   = string  // Default: "Array"
    })
  }))
}

variable "stream_compatibility_level" {
  type        = string
  description = "Compatibility level the stream analytics job, which controls runtime behaviours."
  default     = "1.1"
}

variable "stream_data_locale" {
  type        = string
  description = "Data locale of the stream analytics job."
  default     = "en-GB"
}

variable "stream_late_arrival_delay" {
  type        = number
  description = "mMximum tolerable delay in seconds where events arriving late could be included."
  default     = 60
}

variable "stream_out_of_order_delay" {
  type        = number
  description = "Maximum tolerable delay in seconds where out-of-order events can be adjusted to be back in order."
  default     = 50
}

variable "stream_out_of_order_policy" {
  type        = string
  description = "Policy which should be applied to events which arrive out of order in the input event stream."
  default     = "Adjust"
}

variable "stream_error_policy" {
  type        = string
  description = "Policy which should be applied to events which arrive at the output and cannot be written to the external storage due to being malformed."
  default     = "Drop"
}

variable "stream_streaming_units" {
  type        = number
  description = "Number of streaming units that the streaming job uses."
  default     = 1
}

variable "stream_query" {
  type        = string
  description = "SAQL query that will be run in the streaming job."
  default     = null
}
