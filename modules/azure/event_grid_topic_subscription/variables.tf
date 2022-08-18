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
  type        = string
  description = "Service Bus topic ID where the message should be forwarded"
  default     = null
}
variable "subject_filter" {
  type = object({
    subject_begins_with = optional(string)
    subject_ends_with   = optional(string)
    case_sensitive      = optional(bool)
  })
  description = "parameters for subject filtering"
}

variable "event_types" {
  type = list(string)
  description = "A list of applicable event types that need to be part of the event subscription."
}
