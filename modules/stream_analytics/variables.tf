variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "name" {
  type        = string
  description = "Name of resource."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "storage_connection_string" {
  type        = string
  description = "Connection string of the storage account."
  sensitive   = true
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account."
}

variable "storage_container_name" {
  type        = string
  description = "Name of the storage container."
}

variable "eventhub_name" {
  type        = string
  description = "Name of the event hub."
}

variable "eventhub_namespace_name" {
  type        = string
  description = "Name of the event hub namespace."
}

variable "eventhub_consumer_group_name" {
  type        = string
  description = "Name of the eventhub consumer group."
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

variable "serialization_type" {
  type        = string
  description = "The serialization type used."
  default     = "Json"
}

variable "serialization_name" {
  type        = string
  description = "The encoding of the data."
  default     = "UTF8"
}

variable "serialization_format" {
  type        = string
  description = "The output format of the data."
  default     = "Array"
}

variable "stream_output_path_pattern" {
  type        = string
  description = "The blob path pattern. "
}

variable "stream_output_date_format" {
  type        = string
  description = "The date output format."
  default     = "yyyy/MM/dd"
}

variable "stream_output_time_format" {
  type        = string
  description = "The time output format."
  default     = "HH"
}

variable "stream_query" {
  type        = string
  description = "SAQL query that will be run in the streaming job."
  default     = null # Null values will be set to select all in main.tf
}

variable "eventhub_access_policy_name" {
  type        = string
  description = "The shared access policy name for the event hub."
  default     = "RootManageSharedAccessKey"
}
