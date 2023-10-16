variable "name" {
  type        = string
  description = "Name of the Private Endpoint"
}

variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "private_connection_resource_id" {
  type        = string
  description = "The ID of the resource where the connection should be made to."
}

variable "private_connection_subresource_names" {
  type        = set(string)
  description = "The subresource names of the resource where the connection should be made to."
}

variable "is_manual_connection" {
  type        = bool
  description = "Specifies whether the connection must be approved manually"
}

variable "subnet_id" {
  type        = string
  description = "The Id of the subnet"
}

variable "private_connection_name" {
  type        = string
  description = "The name of the private connection name"
}

variable "private_dns_zone_ids" {
  type        = set(string)
  description = "The IDs of the private DNS zones."
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "The name of the private DNS zone group."
  default     = "deployedByPolicy"
}
