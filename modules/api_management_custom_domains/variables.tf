variable "api_management_id" {
  type        = string
  description = "The ID of the API management service."
}

variable "custom_domains" {
  type = list(object({
    type             = string,
    host_name        = string,
    certificate_name = string,
    key_vault_id     = string,
  }))
  description = "List of custom domains and certificate references for API Management. Type must be one of gateway, management and developer_portal."
  default     = []
}
