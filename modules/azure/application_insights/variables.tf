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
  description = "Specifies the name of the application insights component."
}

variable "application_type" {
  type        = string
  description = "Specifies the type of application insights to create."
  default     = "web"
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "Specifies the application insights daily data volume cap in GB."
  default     = 5
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the retention period in days."
  default     = 30
}

variable "sampling_percentage" {
  type        = number
  description = "Specifies the percentage of the data produced by the monitored application that is sampled for application insights telemetry."
  default     = 20.0
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace."
  default     = null
}
