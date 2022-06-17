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
  description = "Name of the app service."
}

variable "app_service_plan_id" {
  type        = string
  description = "ID of the app service plan."
}

variable "scm_type" {
  type        = string
  description = "The type of Source Control enabled for this App Service."
}

variable "always_on" {
  type        = bool
  description = "Indicates whether the App Service should be always on."
  default     = true
}

variable "use_32_bit_worker_process" {
  type        = bool
  description = "Should the App Service run in 32 bit mode, rather than 64 bit mode?"
  default     = false
}

variable "app_settings" {
  type        = map
  description = "The app settings of this app service."
  default     = {}
}

variable "connection_strings" {
  type = set(
    object({
      name  = string,
      type  = string,
      value = string
  }))
  description = "A list of connection strings used by the app service."
  default     = []
}

variable "linux_fx_version" {
  type        = string
  description = "Linux app framework and version for the app service."
  default     = null
}

variable "dotnet_framework_version" {
  type        = string
  description = "The .NET framework version of this app service."
  default     = "v5.0"
}

variable "websockets_enabled" {
  type        = bool
  description = "Indicates whether websockets are enabled within this app service."
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the app service."
  default     = "1.2"
}

variable "health_check_path" {
  type        = string
  description = "The health check path to be pinged by App Service."
  default     = null
}

variable "integration_subnet_id" {
  type        = string
  description = "The ID of the Subnet from which private IP addresses will be allocated for this Private Endpoint."
  default     = null
}

variable "custom_domains" {
  type        = list
  description = "Define custom domains attached to this app service."
  default     = []
}

variable "auth_enabled" {
  type        = bool
  description = "Indicates whether authentication is enabled for this app service."
  default     = null
}

variable "auth_default_provider" {
  type        = string
  description = "Specifies the default authentication provider."
  default     = null
}

variable "auth_issuer" {
  type        = string
  description = "When using Azure Active Directory, this value is the URI of the directory tenant."
  default     = null
}

variable "unauthenticated_client_action" {
  type        = string
  description = "The action to take when an unauthenticated client attempts to access the app."
  default     = null
}

variable "client_id" {
  type        = string
  description = "The Client ID of this relying party application. Enables OpenIDConnection authentication with Azure Active Directory"
  default     = null
}

variable "client_secret" {
  type        = string
  description = "The Client Secret of this relying party application. If no secret is provided, implicit flow will be used."
  default     = null
}

variable "allowed_audiences" {
  type        = list
  description = "Allowed audience values to consider when validating JWTs issued by Azure Active Directory."
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}
