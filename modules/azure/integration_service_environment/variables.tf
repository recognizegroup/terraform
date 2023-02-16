variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "sku_name" {
  type        = string
  description = "The sku name and capacity of the integration service environment."
  default     = "Developer_0"
}

variable "ise_name" {
  type        = string
  description = "Name of the integration service environment."
}

variable "access_endpoint_type" {
  type        = string
  description = "The type of access endpoint to use for the integration service environment."
  default     = "Internal"
}

variable "virtual_network_subnet_ids" {
  type        = list(any)
  description = "A list of virtual network subnet ids to be used by integration service environment. Exactly four distinct ids to subnets must be provided."
}
