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
  default     = null
}

variable "azurerm_api_diagnostic_settings" {
  type = object({
    sampling_percentage       = number,
    always_log_errors         = bool,
    log_client_ip             = bool,
    verbosity                 = string, # possible values: verbose, information, error
    http_correlation_protocol = string, # possible values: None, Legacy, W3C
  })

  description = "Settings for api management diagnostic, If not needed just privide a null value, Will be created only if api_management_logger_settings have beeen provided"

  default = {
    sampling_percentage       = 5.0,
    always_log_errors         = true,
    log_client_ip             = true,
    verbosity                 = "verbose", # possible values: verbose, information, error
    http_correlation_protocol = "W3C"
  }
}