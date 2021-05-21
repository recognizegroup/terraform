variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of the private DNS zone."
}

variable "private_dns_zone_vnet_link_name" {
  type        = string
  description = "The name of the private DNS zone virtual network link."
}

variable "virtual_network_id" {
  type        = string
  description = "The ID of the virtual network that should be linked to the DNS zone."
}

variable "dns_zone_registration_enabled" {
  type        = bool
  description = "Indicates whether auto-registration of virtual machine records in the virtual network in the Private DNS zone is enabled."
  default     = false
}
