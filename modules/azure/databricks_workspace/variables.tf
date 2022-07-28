variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "managed_resource_group_name" {
  type        = string
  description = "Name of the resource group for databricks managed resources."
}

variable "name" {
  type        = string
  description = "The name of the databricks worskpace."
}

variable "sku" {
  type        = string
  description = "The databricks workspace sku."
  default     = "standard"
}

variable "no_public_ip" {
  type        = bool
  description = "Indicates whether public IP adresses are allowed."
  default     = "true"
}

variable "public_subnet_name" {
  type        = string
  description = "The name of the Public Subnet within the Virtual Network."
}

variable "private_subnet_name" {
  type        = string
  description = "The name of the Private Subnet within the Virtual Network."
}

variable "virtual_network_id" {
  type        = string
  description = "The ID of a Virtual Network where this Databricks Cluster should be created."
}

variable "public_network_access_enabled" {
  type        = string
  description = "Allow public access to databricks workspace."
}
