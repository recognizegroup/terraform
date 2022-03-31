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
  default     = "VSTSRM"
}

variable "always_on" {
  type        = bool
  description = "Indicates whether the App Service should be always on."
  default     = true
}

variable "app_settings" {
  type        = map
  description = "The app settings of this app service."
  default     = {}
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

variable "health_check_path" {
  type        = string
  description = "The health check path to be pinged by app service."
  default     = null
}

variable "integration_subnet_id" {
  type        = string
  description = "The ID of the integration subnet to enable virtual network integration."
}

variable "private_subnet_id" {
  type        = string
  description = "The ID of the subnet from which private IP addresses will be allocated for the Private Endpoint."
}

variable "custom_domains" {
  type        = list
  description = "Define custom domains attached to this app service."
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

variable "storage_mount" {
  type = object({
    name         = string,
    type         = string,
    account_name = string,
    share_name   = string,
    access_key   = string
    mount_path   = string
  })
  description = "Storage container or share to be mount within app service instance(s). Note that container mounts are read-only."
  default     = null
}
