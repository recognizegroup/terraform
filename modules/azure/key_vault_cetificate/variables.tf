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

variable "dns_names"{
  type = list(string)
  description = "List of dns names for the certificate"
  default = []
}

variable "subject" {
  type = string
  description = "Certificate Subject"
}

variable "ignore_changes" {
  type = bool
  description = "specify if portal changes should be overrided on deploy"
  default = false
}