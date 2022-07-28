variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "topic_name" {
  type        = string
  description = "Name of the topic to be created."
}

variable "subscription_name" {
  type        = string
  description = "Name of the subscription to be created."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "storage_account_id" {
  type        = string
  description = "ID of the storage account."
}

variable "webhook_url" {
  type        = string
  description = "URL of the webhook where the Event Subscription will receive events."
  default     = null
}
