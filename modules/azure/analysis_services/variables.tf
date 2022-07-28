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
  description = "The name of the Analysis Services Server."
}

variable "sku" {
  type        = string
  description = "SKU for the Analysis Services Server."
}

variable "admin_users" {
  type        = list
  description = "List of email addresses of admin users."
}

variable "enable_power_bi" {
  type        = bool
  description = "Indicates if the Power BI service is allowed to access or not."
}

variable "ipv4_firewall_rules" {
  type        = list
  description = "List of ipv4 firewall rules with ip addresses allowed to access analysis services."
}
