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
  description = "The name of the API management service."
}

variable "sku" {
  type        = string
  description = "Specifies the API managment pricing model."
  default     = "Developer_1"
}

variable "publisher_name" {
  type        = string
  description = "The name of publisher/company."
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
}

variable "allowed_tenants" {
  type        = list
  description = "List of allowed AAD tenants."
}

variable "owners" {
  type        = list
  description = "List of AAD object IDs to set as API management owners."
  default     = []
}

variable "virtual_network_type" {
  type        = string
  description = "The id of the subnet that will be used for the API Management."
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet from which private IP addresses will be allocated for the Private Endpoint."
  default     = null
}

variable "api_management_logger_settings"{
  type = object({
    name                    = string, 
    application_insights_id = string,
    instrumentation_key     = string
  })

  description = "Api Management Logger Settings, if null the resource will not be created "
  default     = null
}

variable "azurerm_api_management_diagnostic_settings"{
  type = object({
    sampling_percentage       = number, 
    always_log_errors         = boolean,
    log_client_ip             = boolean,
    verbosity                 = string, # possible values: verbose, information, error
    http_correlation_protocol = string, # possible values: None, Legacy, W3C
  })
  description = "Settings for api management diagnostic, 
                 If not needed just privide a null value,
                 Will be created only if api_management_logger_settings have beeen provided"

  default ={
    sampling_percentage       = 5.0,
    always_log_errors         = true,
    log_client_ip             = true,
    verbosity                 = "Verbose", # possible values: verbose, information, error
    http_correlation_protocol = "W3C"
  }
}
