variable "name" {
  type        = string
  description = "Name of the certificate"
}

variable "key_vault_id" {
  type        = string
  description = "Key vault ID"
}

variable "key_properties" {
  type = object({
    key_size = number,
    key_type = string
  })
  description = "key properties for certificate_policy of Certificate"

  default = {
    key_size = "4096"
    key_type = "RSA"
  }
}
