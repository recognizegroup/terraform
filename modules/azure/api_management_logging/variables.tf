variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "api_management_logger_name" {
  type        = string
  description = ""
}

variable "application_insights_id" {
  type        = string
  description = ""
}

variable "application_insights_instrumentation_key" {
  type        = string
  description = ""
}

variable "api_names" {
  type        = set(string)
  description = ""
}

variable "log_payload_size" {
  type        = number
  description = "max payload side to log "
  default     = 32
}

variable "sampling_percentage" {
  type        = number
  description = "% of requests to log"
  default     = 5
}
