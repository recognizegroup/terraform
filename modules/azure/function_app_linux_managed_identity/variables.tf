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
  description = "Specifies the name of the function app."
}

variable "dotnet_version" {
  type        = string
  description = "Specifies the version of dotnet."
  default     = ""
}

variable "dotnet_isolated" {
  type        = bool
  description = "Specifies if it is isolated function app."
  default     = false
}

variable "managed_identity_provider" {
  type = object({
    existing = optional(object({
      client_id     = string
      client_secret = string
    }))
    create = optional(object({
      application_name = string
      display_name     = string
      oauth2_settings = object({
        admin_consent_description  = string
        admin_consent_display_name = string
        enabled                    = bool
        type                       = string
        user_consent_description   = string
        user_consent_display_name  = string
        role_value                 = string
      })
      owners        = optional(list(string)) # Deployment user will be added as owner by default
      redirect_uris = optional(list(string)) # Only for additional URIs, function uri will be added by default
      group_id      = optional(string)       # Group ID where service principal of the existing application will belong to
    }))
    identifier_uris   = optional(list(string)) #  api://<application_name> will be added by default if application is create
    allowed_audiences = optional(list(string)) # api://<application-name> will be added by default
  })
  validation {
    condition     = var.managed_identity_provider.existing != null || var.managed_identity_provider.create != null
    error_message = "Variable managed_identity_provider has to provide either an existing managed identity provider or given information to create one"
  }
  description = "The managed identity provider to use for connections on this function app"
}

variable "service_plan_id" {
  type        = string
  description = "The ID of the Service Plan within which to create this Function App."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

variable "storage_account_name" {
  type        = string
  description = "The backend storage account name which will be used by this Function App (such as the dashboard, logs)."
}

variable "storage_account_access_key" {
  type        = string
  description = "DEPRECATED in favor of use_managed_identity instead. The access key which will be used to access the backend storage account for the Function App."
  default     = null
}

variable "use_managed_identity" {
  type        = bool
  description = "Adds managed identity to the function app, that allows to avoid explicit access token usage"
  default     = null
}

variable "app_settings" {
  type        = map(any)
  description = "The app settings of this app service."
  default     = {}
}

variable "runtime_version" {
  type        = string
  description = "The runtime version associated with the Function App."
  default     = "~4"
}

variable "always_on" {
  type        = bool
  description = "Should the Function App be loaded at all times?"
  default     = false
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Connection strings for the function app."
  default     = []
}

variable "integration_subnet_id" {
  type        = string
  description = "Define the subnet in which the Function App runs."
  default     = null
}

variable "route_all_outbound_traffic" {
  type        = bool
  description = "Defines whether all outbound traffic of the Function App is routed."
  default     = false
}

variable "ip_restrictions" {
  type = list(object({
    ip_address                = optional(string),
    service_tag               = optional(string),
    virtual_network_subnet_id = optional(string),
    name                      = optional(string),
    priority                  = optional(number),
    action                    = optional(string),

    headers = optional(list(object({
      x_azure_fdid      = optional(list(string)),
      x_fd_health_probe = optional(list(string)),
      x_forwarded_for   = optional(list(string)),
      x_forwarded_host  = optional(list(string))
    })))
  }))
  description = "A List of objects representing ip restrictions."
  default     = []
}

variable "authentication_settings" {
  type = object({
    require_authentication = optional(bool),
    unauthenticated_action = optional(string)
    excluded_paths         = optional(list(string))
  })
  description = "Authentification settings for the Function app"
  default = {
    require_authentication = true,
    unauthenticated_action = "RedirectToLoginPage",
    excluded_paths         = []
  }
}

variable "use_32_bit_worker" {
  type        = bool
  description = "Should the Linux Web App use a 32-bit worker process."
  default     = true
}
