variable "name" {
  type        = string
  description = "Subscription NAme"
}

variable "system_topic_name" {
  type        = string
  description = "Name of the topic to be created."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "webhook_url" {
  type        = string
  description = "URL of the webhook where the Event Subscription will receive events."
  default     = null
}

variable "service_bus_topic_id" {
  type = string
  description = "Service Bus topic ID where the message should be forwarded"
  default = null
}
