variable "named_values" {
  type = list(object({
    name    = string,
    value   = optional(string),
    encrypt = optional(bool), // Whether or not this value should be encrypted. Does not affect sensitive value during deployment, but encrypts it in the apim named values
    key_vault_secret_id = optional(string) // The ID of the key vault secret to use for this named value
  }))
  description = "List of named values to add to the api management instance."
}

variable "api_management_name" {
  type        = string
  description = "The name of the APIM instance where the named value should be."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the APIM is located."
}
