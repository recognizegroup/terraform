variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "data_factory_id" {
  type        = string
  description = "The ID of the data factory."
}

variable "source_storage_account_key" {
  type        = string
  description = "Access key of the source storage account."
  sensitive   = true
}

variable "source_storage_account_url" {
  type        = string
  description = "URL of the source storage account."
}

variable "source_storage_container_name" {
  type        = string
  description = "Name of the source storage container or filesystem."
}

variable "source_service_name" {
  type        = string
  description = "The name of the data factory source blob service."
}

variable "source_dataset_name" {
  type        = string
  description = "The name of the data factory source blob dataset."
}

variable "target_storage_account_key" {
  type        = string
  description = "Access key of the target storage account."
  sensitive   = true
}

variable "target_storage_account_url" {
  type        = string
  description = "URL of the target storage account."
}

variable "target_storage_container_name" {
  type        = string
  description = "Name of the target storage container or filesystem."
}

variable "target_service_name" {
  type        = string
  description = "The name of the data factory target blob service."
}

variable "target_dataset_name" {
  type        = string
  description = "The name of the data factory target blob dataset."
}

variable "pipeline_name" {
  type        = string
  description = "The name of the data factory pipeline."
}

variable "schedule_name" {
  type        = string
  description = "The name of the data factory schedule."
}

variable "schedule_interval" {
  type        = number
  description = "The interval of the data factory schedule."
  default     = 1
}

variable "schedule_frequency" {
  type        = string
  description = "The frequency of the data factory schedule."
  default     = "Day"
}
