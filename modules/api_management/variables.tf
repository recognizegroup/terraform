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
  type        = list(string)
  description = "List of allowed AAD tenants."
}

variable "owners" {
  type        = list(string)
  description = "List of AAD object IDs to set as API management owners."
  default     = []
}

variable "redirect_uris" {
  type        = list(string)
  description = "List of additional redirect URIs for authenticating with the developer portal."
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

variable "api_management_logger_settings" {
  type = object({
    name                    = string,
    application_insights_id = string,
    instrumentation_key     = string
  })
  description = "Api Management Logger Settings, specifies to what application insights to forward the Log data, if null the resource will not be created "
  default     = null
}

variable "api_management_diagnostic_settings" {
  type = object({
    sampling_percentage       = number,
    always_log_errors         = bool,
    log_client_ip             = bool,
    verbosity                 = string, # possible values: verbose, information, error
    http_correlation_protocol = string, # possible values: None, Legacy, W3C
  })
  description = "Settings for api management diagnostic, api-management-diagnostic will be created only if api_management_logger_settings have been provided. "
  default = {
    sampling_percentage       = 5.0,
    always_log_errors         = true,
    log_client_ip             = true,
    verbosity                 = "verbose", # possible values: verbose, information, error
    http_correlation_protocol = "W3C"
  }
}

variable "alert_rules_settings" {
  type = list(object({
    name          = string,
    severity      = string,       # possible values: Sev0, Sev1, Sev2, Sev3 or Sev4
    frequency     = string,       # frequency in ISO-8601 eg. PT1M -> 1 per Month
    detector_type = string,       # possible values see: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_smart_detector_alert_rule#detector_type
    action_groups = list(string), # ids of Action Groups
    scope_ids     = list(string)  # scopes for alert rule, e.g. Application Insights Id
  }))

  description = "Defines Settings for a list of alert rules, within Azure Monitor"
  default     = []
}

variable "public_ip_address_id" {
  type        = string
  description = "ID of a standard SKU IPv4 Public IP."
  default     = null
}

variable "xml_content" {
  type        = string
  description = "The XML content for applying an APIM policy globally."
  default     = null
}

variable "signin_tenant" {
  type        = string
  description = "The signin tenant to use for registering AAD users in the developer portal"
  default     = null
}
