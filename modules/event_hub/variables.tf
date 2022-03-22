variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "namespace_name" {
  type        = string
  description = "Name of the event hub namespace."
}

variable "namespace_sku" {
  type        = string
  description = "Event hub namespace pricing tier."
  default     = "Standard"
}

variable "namespace_capacity" {
  type        = number
  description = "Number of throughput units for the event hub namespace."
  default     = 1
}

variable "eventhub_name" {
  type        = string
  description = "Name of the event hub."
}

variable "partition_count" {
  type        = number
  description = "Number of partitions for the event hub."
  default     = 2
}

variable "message_retention" {
  type        = number
  description = "Retention period of messages for the event hub."
  default     = 1
}

variable "consumer_group_name" {
  type        = string
  description = "Eventhub consumer group name."
}
