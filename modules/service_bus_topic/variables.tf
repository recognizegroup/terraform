variable "name" {
  type        = string
  description = "Name of the storage account."
}

variable "namespace_id" {
  type        = string
  description = "Namespace of the Service Bus."
}

variable "default_message_ttl" {
  type        = string
  description = "Default TTL (time to live) of messages with unspecified TTL."
  default     = "P30D" # (Arbitrary) 30 day TTL (in ISO 8601 format).
}

variable "max_size_in_megabytes" {
  type        = number
  description = "Maximum topic size in MB."
  default     = 1024 # Default portal value.
}

variable "enable_partitioning" {
  type        = bool
  description = "Enable the topic to be partitioned across multiple message brokers."
  default     = false
}

variable "requires_duplicate_detection" {
  type        = bool
  description = "Enable duplication detection."
  default     = false
}
