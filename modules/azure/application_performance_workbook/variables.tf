variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "workbook_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workbook."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace."
}
