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
  description = "Name of the web app."
}

variable "service_plan_id" {
  type        = string
  description = "ID of the service plan."
}

variable "always_on" {
  type        = bool
  description = "Indicates whether the Web App should be always on."
  default     = true
}

variable "app_settings" {
  type        = map(any)
  description = "The app settings of this web app."
  default     = {}
}

variable "dotnet_version" {
  type        = string
  description = "The .NET framework version of this web app."
  default     = "v5.0"
}

variable "docker_image" {
  type        = string
  description = "Docker image for the web app."
  default     = null
}

variable "docker_image_tag" {
  type        = string
  description = "Docker image tag for the web app."
  default     = null
}

variable "websockets_enabled" {
  type        = bool
  description = "Indicates whether websockets are enabled within this web app."
  default     = true
}

variable "health_check_path" {
  type        = string
  description = "The health check path to be pinged by web app."
  default     = null
}

variable "integration_subnet_id" {
  type        = string
  description = "The ID of the integration subnet to enable virtual network integration."
  default     = null
}

variable "private_subnet_id" {
  type        = string
  description = "The ID of the subnet from which private IP addresses will be allocated for the Private Endpoint."
  default     = null
}

variable "custom_domains" {
  type        = set(string)
  description = "Define custom domains attached to this web app."
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

variable "use_32_bit_worker" {
  type        = bool
  description = "Should the Web App run in 32 bit mode, rather than 64 bit mode?"
  default     = false
}

variable "ftps_state" {
  type        = string
  description = "State of FTP / FTPS service for this Web App."
  default     = "FtpsOnly"
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
  description = "Storage container or share to be mount within web app instance(s). Note that container mounts are read-only."
  default     = null
}
