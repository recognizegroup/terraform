variable "secrets" {
  type = list(object({
    secret_name  = string
    secret_value = string
  }))
  description = "A list containing secret objects."
  sensitive   = true
}

variable "key_vault_id" {
  type        = string
  description = "ID of the key vault."
}

variable "expiration_date" {
  type        = string
  description = "Date secrete expires"
  default     = null
}
