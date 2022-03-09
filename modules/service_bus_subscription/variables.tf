variable "name" {
  type        = string
  description = "Name of the storage account."
}

variable "topic_id" {
  type        = string
  description = "ID of the topic to subscribe to."
}

variable "max_delivery_count" {
  type        = number
  description = "Maximum number of deliveries."
  default     = 1 # Default portal value.
}
