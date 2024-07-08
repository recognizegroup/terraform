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
  description = "Name of the virtual network."
}

variable "address_space" {
  type        = list(string)
  description = "Address space of the virtual network."
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
