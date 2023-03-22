variable "secrets" {
  type = list(object({
    secret_name     = string
    secret_value    = string
    expiration_date = optional(string)
  }))
  description = "A list containing secret objects."
  sensitive   = true
}

variable "key_vault_id" {
  type        = string
  description = "ID of the key vault."
}
