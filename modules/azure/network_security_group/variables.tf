variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "network_security_group_name" {
  type        = string
  description = "Specifies the name of the network security group."
}

variable "security_rules" {
  type = list(
    object({
      name                       = string
      priority                   = string
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      source_port_ranges         = optional(list(string))
      destination_port_range     = optional(string)
      destination_port_ranges    = optional(list(string))
      source_address_prefix      = string
      destination_address_prefix = string
    })
  )
  description = "List of security rules."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to associate with network security group."
  default     = []
}


variable "loganalytics_diagnostic_setting" {
  type        = object({
      workspace_id     = string, // log analytics workspace ID
      categories = optional(list(string)), // null list,means send all categories
      metrics  = optional(list(string)), // null list means send all metrics
  })
  description = "Specifies the log categories that have to be sent to Log analytics."
  default     = null
}
