variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "client_id" {
  type        = string
  description = "Azure client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure client secret"
}

variable "skip_provider_registration" {
  type        = string
  description = "Indicates whether the provider should be registered in Azure"
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a resource group in Azure"
}

variable "eventhub_namespace_name" {
  type        = string
  description = "Name of the event hub namespace"
}

variable "location" {
  type        = string
  description = "A datacenter location in Azure"
}

variable "sku" {
  type        = string
  description = "Azure Event hub pricing tier"
  default     = "Standard"
}

variable "capacity" {
  type        = number
  description = "Number of throughput units for the Azure event hub"
  default     = 1
}

variable "eventhub_name" {
  type        = string
  description = "Name of the event hub"
}

variable "partition_count" {
  type        = number
  description = "Number of partitions for the azure Avent hub"
  default     = 2
}

variable "message_retention" {
  type        = number
  description = "Retention period of messages for the Azure event hub"
  default     = 1
}

variable "eventhub_rule_name" {
  type        = string
  description = "Name of the event hub authorization rule"
}
