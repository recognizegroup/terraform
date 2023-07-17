variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Name of the storage account"
}

variable "kind" {
  type        = string
  description = "Defines the kind to use for this storage account."
  default     = "StorageV2"
}

variable "tier" {
  type        = string
  description = "Defines the tier to use for this storage account."
  default     = "Standard"
}

variable "replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."
  default     = "GRS"
}

variable "allow_public_access" {
  type        = bool
  description = "Allow or disallow public access to all blobs or containers in the storage account."
  default     = false
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account."
  default     = "TLS1_2"
}

variable "nfsv3_enabled" {
  type        = bool
  description = "Is NFSv3 protocol enabled?"
  default     = false
}

variable "is_hns_enabled" {
  type        = bool
  description = "Is Hierarchical Namespace enabled?"
  default     = false
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Forces HTTPS when true"
  default     = true
}

variable "authentication_directory_type" {
  type        = string
  description = "Active Directory Authentification Service Used. Possible Values AADDS and AD"
  default     = null
}

variable "auto_delete_rules" {
  type = set(object({
    name                    = string,
    prefixes                = list(string), // Blob prefixes for fillering
    days_after_creation     = optional(number),
    days_after_access       = optional(number),
    days_after_modification = optional(number)
  }))

  description = "Describes the rules for auto deleting files after actions like creation, access of modification of a blob"
  default     = null
}

variable "cors_rules" {
  type = set(object({
    allowed_headers    = list(string),
    allowed_methods    = list(string),
    allowed_origins    = list(string),
    exposed_headers    = list(string),
    max_age_in_seconds = number
  }))
  description = "Describes the CORS rules for the storage account"
  default     = null
}

variable "static_website" {
  type = object({
    index_document = string,
    error_document = string
  })
  description = "Describes the static website configuration for the storage account"
  default     = null
}

variable "custom_domain" {
  type = object({
    name                = string,
    use_sub_domain_name = bool
  })
  description = "Describes the custom domain configuration for the storage account"
  default     = null
}