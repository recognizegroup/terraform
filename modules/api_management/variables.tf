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

variable "api_management_logger"{
  type = object({
    name                    = string, 
    application_insights_id = string,
    instrumentation_key     = string
  })

  description = "Api Management Logger Settings, "
  default     = null
}
