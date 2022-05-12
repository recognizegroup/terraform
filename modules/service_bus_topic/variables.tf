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
  default     = "P14D" # 14 day TTL (in ISO 8601 format).
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

variable "duplicate_detection_history_time_window" {
  type        = string
  description = "ISO 8601 timespan duration during which duplicates can be detected."
  default     = "PT10M" # 10 minutes in ISO 8601 (portal default)
}

variable "enable_batched_operations" {
  type        = bool
  description = "Enables Server-Side batched operations."
  default     = true
}

variable "status" {
  type        = string
  description = "The Status of the Service Bus Topic."
  default     = "Active"
}

variable "support_ordering" {
  type        = bool
  description = "Whether or not the topic supports ordering"
  deault      = true
}

variable "auto_delete_on_idle" {
  type        = string
  description = "timespan duration of the idle interval after which the Topic is automatically deleted."
  default     = "P10675199DT2H48M5.4775807S" # Maximum allowed time (ISO 8601 format)
}

variable "enable_express" {
  type        = bool
  description = "Whether Express Entities are enabled."
  default     = false
}
