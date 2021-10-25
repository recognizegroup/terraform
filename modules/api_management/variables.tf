variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "api_management_sku" {
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

variable "application_name" {
  type        = string
  description = "Azure AD application name."
}

variable "id_provider_allowed_tenants" {
  type        = list
  description = "List of allowed AAD tenants."
}

variable "client_id" {
  type        = string
  description = "Client ID of the app registration for APIM AAD provider."
}

variable "client_secret" {
  type        = string
  description = "Client secret of the app registration for APIM AAD provider."
}
