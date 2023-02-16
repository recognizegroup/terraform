variable "name" {
  type        = string
  description = "certificate name"
}

variable "api_management_name" {
  type        = string
  description = "The Name of API Manager Where to Add the certificate"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name where the Api Management is located"
}

variable "keyvault_certificate_id" {
  type        = string
  description = "the id of the certificate file in a keyvault"
  default     = null
}

variable "certificate_location" {
  type        = string
  description = "location of client certificate"
  default     = null
}

variable "certificate_password" {
  type        = string
  sensitive   = true
  description = "password for Pfx File"
  default     = null
}