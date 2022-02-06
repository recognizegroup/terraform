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
  description = "The name of the subnet."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network."
}

variable "address_prefixes" {
  type        = list
  description = "The address prefix to use for the subnet."
}

variable "route_table_id" {
  type        = string
  description = "The ID of the route table which should be associated with the subnet."
  default     = null
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  description = "Enable or Disable network policies for the private link endpoint on the subnet."
  default     = false
}

variable "service_delegation" {
  type        = string
  description = "The name of service to delegate to."
  default     = null
}

variable "service_endpoints" {
  type        = list
  description = "The list of Service endpoints to associate with the subnet."
  default     = []
}
