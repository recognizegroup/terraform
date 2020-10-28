variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "datalake_storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "datalake_storage_container_name" {
  type        = string
  description = "Name of the storage container."
}

variable "skip_provider_registration" {
  type        = bool
  description = "Indicates whether the provider should be registered in Azure."
  default     = false
}

variable "data_factory_name" {
  type        = string
  description = "The name of the datafactory."
}

variable "data_factory_pipeline_name" {
  type        = string
  description = "The name of the data factory pipeline."
}

variable "service_http_template_name" {
  type        = string
  description = "The name of the data factory REST service ARM template."
}

variable "service_http_name" {
  type        = string
  description = "The name of the data factory REST service."
}

variable "service_http_authentication_type" {
  type        = string
  description = "The authentication type of the data factory REST service."
  default     = "Anonymous"
}

variable "service_http_url" {
  type        = string
  description = "The url of the data factory REST service."
  default     = "Anonymous"
}

variable "dataset_web_name" {
  type        = string
  description = "The name of the data factory http dataset."
}

variable "dataset_web_relative_url" {
  type        = string
  description = "The relative url of the data factory http dataset."
}

variable "dataset_web_request_method" {
  type        = string
  description = "The request method of the data factory http dataset."
  default     = "Get"
}

variable "service_blob_name" {
  type        = string
  description = "The name of the data factory blob service."
}

variable "dataset_blob_name" {
  type        = string
  description = "The name of the data factory blob dataset."
}

variable "dataset_blob_filename" {
  type        = string
  description = "The filename of the data factory blob dataset."
}

variable "data_factory_schedule_name" {
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
