variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "source_vm_ids" {
  type        = list(string)
  description = "List of virtual machines IDs to backup."
}

variable "recovery_services_vault_name" {
  type        = string
  description = "Specifies the name of the recovery services vault."
}

variable "recovery_services_vault_sku" {
  type        = string
  description = "Sets the sku of the recovery services vault."
  default     = "Standard"
}

variable "backup_policy_vm_name" {
  type        = string
  description = "Specifies the name of the backup policy."
}

variable "backup_policy_vm_timezone" {
  type        = string
  description = "Specifies the timezone of the backup policy."
  default     = "UTC"
}

variable "backup_policy_vm_frequency" {
  type        = string
  description = "Specifies the frequency of the backup."
}

variable "backup_policy_vm_time" {
  type        = string
  description = "Specifies the time on which to perform the backup."
}

variable "backup_policy_vm_retention" {
  type        = number
  description = "Specifies the retention of existing backups."
}
