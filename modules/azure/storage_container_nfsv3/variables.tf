variable "storage_container_name" {
  type        = string
  description = "Name of the storage container."
}

variable "storage_account_id" {
  type        = string
  description = "Storage account Id"
}

variable "ace_permissions" {
  type = list(object({
    type        = string,
    permissions = string,
    scope       = optional(string)
  }))

  description = "list of ACE permisions"
  default     = []
}


variable "directories" {
  type        = list(string)
  description = "List of directories"
}
