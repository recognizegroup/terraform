variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace."
}

variable "sku" {
  type        = string
  description = "Specifies the Sku of the Log Analytics Workspace."
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "The workspace data retention in days."
  default     = 30
}

variable "daily_quota_gb" {
  type        = number
  description = "The workspace daily quota for ingestion in GB."
  default     = 5
}
