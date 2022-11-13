variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account for the Synapse workspace."
}

variable "filesystem_name" {
  type        = string
  description = "Name of the adls gen2 filesystem."
}

variable "workspace_name" {
  type        = string
  description = "Name of the Synapse workspace."
}

variable "sql_admin_login" {
  type        = string
  description = "Login name for the Synapse sql admin."
}

variable "sql_admin_password_keeper" {
  type        = string
  description = "Password keeper for the Synapse sql admin."
}

variable "compute_subnet_id" {
  type        = string
  description = "Subnet ID for the Synapse compute nodes."
  default     = null
}

variable "data_exfiltration_protection_enabled" {
  type        = bool
  description = "Enable data exfiltration protection."
  default     = null
}

variable "linking_allowed_for_aad_tenant_ids" {
  type        = list(string)
  description = "List of AAD tenant IDs that are allowed to link to the Synapse workspace."
  default     = []
}

variable "managed_resource_group_name" {
  type        = string
  description = "Name of the managed resource group."
  default     = null
}

variable "managed_virtual_network_enabled" {
  type        = bool
  description = "Enable managed virtual network for the Synapse workspace."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access for the Synapse workspace."
  default     = true
}

variable "aad_admin_object_id" {
  type        = string
  description = "Object ID of the AAD admin."
}

variable "aad_admin_tenant_id" {
  type        = string
  description = "Tenant ID of the AAD admin."
}

variable "github" {
  type = object({
    account_name    = string,
    branch_name     = string,
    repository_name = string,
    root_folder     = string,
    last_commit_id  = optional(string),
    git_url         = optional(string)
  })
  description = "Github repository configuration to link to the Synapse workspace."
  default     = null
}

variable "devops" {
  type = object({
    account_name    = string,
    project_name    = string
    branch_name     = string,
    repository_name = string,
    root_folder     = string,
    last_commit_id  = optional(string),
    tenant_id       = optional(string)
  })
  description = "Devops repository configuration to link to the Synapse workspace."
  default     = null
}

variable "role_assignments" {
  type = list(object({
    object_id = string
    role_name = string
  }))
  description = "List of role assignments for the Synapse workspace."
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}
