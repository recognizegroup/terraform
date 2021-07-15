variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "app_service_name" {
  type        = string
  description = "Name of the app service."
}

variable "app_service_plan_id" {
  type        = string
  description = "ID of the app service plan."
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

variable "private_endpoint_name" {
  type        = string
  description = "Specifies the name of the Private Endpoint."
  default     = ""
}

variable "integration_subnet_id" {
  type        = string
  description = "The ID of the Subnet from which private IP addresses will be allocated for this Private Endpoint."
}

variable "private_subnet_id" {
  type        = string
  description = "The ID of the Subnet from which private IP addresses will be allocated for the Private Endpoint."
}

variable "private_service_connection_name" {
  type        = string
  description = "Specifies the Name of the Private Service Connection."
}

variable "custom_domains" {
  type        = list
  description = "Define custom domains attached to this app service."
  default     = []
}
