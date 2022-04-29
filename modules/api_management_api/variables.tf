variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

# variable "api_management_group_name" {
#   type        = string
#   description = "The name of the API management group."
# }

variable "openapi_file_path"{
  type        = string
  description = "Path to an openAPI .yaml file that describes this API"
}

variable "api_management_logger_id"{
  type        = string
  description = "The Id of the API management Logger"
}

variable "allways_log_errors"{
  type        = bool
  description = "wether to Always log errors. Regardless of sampling settings."
  default     = true
}

variable "verbosity"{
  type        = string
  description = "Logging verbosity. Possible values are 'verbose', 'information' or 'error'."
  default     = "verbose"
}
