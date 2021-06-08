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

variable connection_string_name {
  type        = string
  description = "name of the connection string"
}

variable connection_string_value {
  type        = string
  description = "value of the connection string"
}

variable "private_endpoint_name" {
  type        = string
  description = "Specifies the name of the Private Endpoint."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which private IP addresses will be allocated for this Private Endpoint."
}

variable "private_subnet_id" {
  type        = string
  description = "Specifies the Name of the Private Service Connection."
}

variable "private_service_connection_name" {
  type        = string
  description = "Specifies the Name of the Private Service Connection."
}

variable "private_service_connection_is_manual" {
  type        = bool
  description = "Indicates whether the Private Endpoint requires manual approval from the remote resource owner?"
  default     = false
}

variable "private_service_connection_subresource_names" {
  type        = list
  description = "A list of subresource names which the Private Endpoint is able to connect to."
  default     = [
    "sites"]
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "Specifies the name of the private DNS zone group."
}

variable "private_dns_zone_ids" {
  type        = list
  description = "Specifies a list of private DNS zones IDs"
  default     = []
}
