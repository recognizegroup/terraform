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

variable "trigger_name" {
  type        = string
  description = "The name of the data factory trigger."
}

variable "trigger_start_time" {
  type        = string
  description = "Specifies the start time of trigger, formatted as an RFC3339 string."
}

variable "trigger_end_time" {
  type        = string
  description = "Specifies the end time of trigger, formatted as an RFC3339 string."
}

variable "trigger_frequency" {
  type        = string
  description = "Specifies the frequency of trigger. Possible values are Hour, Minute and Month."
}

variable "trigger_interval" {
  type        = number
  description = "Specifies the interval of trigger."
}

variable "trigger_concurrency" {
  type        = number
  description = "The max number for simultaneous trigger runs."
  default     = 1
}

variable "trigger_activated" {
  type        = bool
  description = "Specifies if the trigger is activated."
  default     = true
}

variable "trigger_retry_count" {
  type        = number
  description = "The maximum retry attempts if the pipeline run failed."
  default     = 1
}

variable "trigger_retry_interval" {
  type        = number
  description = "The Interval in seconds between each retry if the pipeline run failed."
  default     = 30
}

variable "trigger_parameters" {
  type        = map(any)
  description = "Pipeline parameters that the trigger will act on."
  default     = {}
}


