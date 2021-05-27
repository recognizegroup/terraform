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
  description = "Id of the ASP."
}

variable app_settings {
  type        = map(string)
  description = "the app settings of this app service"
  default     = {}
}

variable dotnet_framework_version {
  type        = string
  description = "The .NET framework version of this app service"
}

variable websockets_enabled {
  type        = bool
  description = "Are websockets enabled within this app service"
  default     = false
}

variable "custom_domain" {
  type        = set(string)
  description = "Define custom domains attached to this app service"
  default     = []
}

variable connection_string_name{
  type        = string
  description = "name of the connection string"
}

variable connection_string_value{
  type        = string
  description = "value of the connection string"
}
