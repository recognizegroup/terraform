variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "api_settings" {
  type = object({
    name                  = string,
    description           = optional(string),
    service_url           = string,
    revision              = string,
    basepath              = string,
    subscription_required = string,
    openapi_file_path     = optional(string),
    wsdl_file_path        = optional(string)
  })
  description = "Settings to use for this API. Either Openapi or wsdl file path should be set."
}

variable "backend_type" {
  type        = string
  description = "The type of backend used by the api. Should be public, basic auth or managed identity"

  validation {
    condition     = contains(["public", "basic auth", "managed identity"], var.backend_type)
    error_message = "Argument \"backend_type\" must be either \"public\", \"basic auth\", or \"managed identity\"."
  }
}

variable "managed_identity_resource" {
  type        = string
  description = "The resource to validate the managed identity"
  default     = null
}

variable "basic_auth_settings" {
  type = object({
    key_vault_id  = string,
    username_name = string,
    password_name = string,
  })
  description = "Settings to be used for basic auth"
  default     = null
}

variable "wsdl_selector" {
  type = object({
    service_name  = string,
    endpoint_name = string
  })
  description = "A selector for the wsdl file when only part of the document should be used"
  default     = null
}

variable "aad_settings" {
  type = object({
    openid_url = string,
    issuer     = string
  })
  description = "An object representing the settings to be used for AAD authentication"
  default     = null
}

variable "owners" {
  type        = list(any)
  description = "List of AAD object IDs to set as API management owners."
  default     = []
}

variable "object_ids" {
  type        = list(string)
  description = "managed identity object ids that want access to the through AAD application"
}

variable "api_management_logger_id" {
  type        = string
  description = "The Id of the API management Logger"
  default     = null
}

variable "api_diagnostic_settings" {
  type = object({
    sampling_percentage       = number,
    always_log_errors         = bool,
    log_client_ip             = bool,
    verbosity                 = string, # possible values: verbose, information, error
    http_correlation_protocol = string, # possible values: None, Legacy, W3C
  })

  description = "Settings for api diagnostics, If not needed just privide a null value, Will be created only if api_management_logger_id have beeen provided"

  default = {
    sampling_percentage       = 5.0,
    always_log_errors         = true,
    log_client_ip             = true,
    verbosity                 = "verbose", # possible values: verbose, information, error
    http_correlation_protocol = "W3C"
  }
}

variable "authorization_tenant" {
  type        = string
  description = "the tenant to use for oauth requests. If not using custom auth/token endpoints this value should be set"
  default     = null
}

variable "auth_endpoint" {
  type        = string
  description = "Override for authorization endpoint in case custom oauth2 endpoints are used."
  default     = null
}

variable "token_endpoint" {
  type        = string
  description = "Override for token endpoint in case custom oauth2 endpoints are used."
  default     = null
}

variable "client_registration_endpoint" {
  type        = string
  description = "URI/URL for the location of client & app registration."
  default     = "http://localhost"
}

variable "developer_portal_url" {
  type        = string
  description = "url to the apim developer portal where this api is located"
  default     = null
}

