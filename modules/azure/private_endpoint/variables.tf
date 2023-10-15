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

variable "private_connection_resource_subresource_type" {
  type        = string
  description = "The subresource type of the resource where the connection should be made to."
}

variable "subnet_id" {
  type        = string
  description = "The Id of the subnet"
}

variable "private_connection_name" {
  type        = string
  description = "The name of the private connection name"
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the private DNS zone."
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "The name of the private DNS zone group."
  default     = "deployedByPolicy"
}
