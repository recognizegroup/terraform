variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "resource_group_id" {
  type        = string
  description = "Identifier of the resource group."
}

variable "cost_management_export_storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "cost_management_export_storage_account_kind" {
  type        = string
  description = "Defines the kind to use for this storage account."
  default     = "StorageV2"
}

variable "cost_management_export_storage_account_tier" {
  type        = string
  description = "Defines the tier to use for this storage account."
  default     = "Standard"
}

variable "cost_management_export_storage_account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."
  default     = "LRS"
}

variable "cost_management_export_name" {
  type        = string
  description = "Defines the name of the cost management export job."
}

variable "cost_management_export_container_name" {
  type        = string
  description = "Defines the name of the cost management export container."
  default     = "costmanagement"
}

variable "cost_management_export_root_folder_path" {
  type        = string
  description = "Defines the root folder inside the storage account to where the cost management export will be saved."
  default     = "exports"
}

variable "cost_management_export_type" {
  type        = string
  description = "Defines the export type of the cost management"
  default     = "Usage"
}

variable "cost_management_export_time_frame" {
  type        = string
  description = "Defines the timeframe for the cost management export."
  default     = "TheLastMonth"
}

variable "cost_management_export_recurrence_type" {
  type        = string
  description = "Defines the recurrence type for the cost management export."
  default     = "Monthly"
}

variable "cost_management_export_recurrence_period_start" {
  type        = string
  description = "Defines the date at which the cost management export starts capturing data."
  default     = "2021-02-01T00:00:00Z"
}

variable "cost_management_export_recurrence_period_end" {
  type        = string
  description = "Defines the date at which the cost management export starts capturing data."
  default     = "2030-12-31T00:00:00Z"
}

variable "cost_management_logic_app_workflow_name" {
  type        = string
  description = "Defines the name of the logic app sending the export."
}

variable "send_export_to" {
  type        = string
  description = "Defines the email address to send the export to"
}

variable "send_export_to_cc" {
  type        = string
  description = "Defines the cc email addresses to send the export to"
}
