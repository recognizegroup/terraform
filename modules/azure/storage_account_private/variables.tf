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

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account."
  default     = "TLS1_2"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which private IP addresses will be allocated for the Private Endpoint."
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

variable "private_dns_zone_id" {
  type = string
  description = "ID of the private DNS zone."
}
