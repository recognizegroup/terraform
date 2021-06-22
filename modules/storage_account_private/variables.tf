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
  description = "Name of the storage account"
}

variable "storage_account_kind" {
  type        = string
  description = "Defines the kind to use for this storage account."
  default     = "StorageV2"
}

variable "storage_account_tier" {
  type        = string
  description = "Defines the tier to use for this storage account."
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."
  default     = "LRS"
}

variable "storage_account_min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account."
  default     = "TLS1_2"
}

variable "private_endpoint_name" {
  type        = string
  description = "Specifies the name of the Private Endpoint."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which private IP addresses will be allocated for the Private Endpoint."
}

variable "private_service_connection_name" {
  type        = string
  description = "Specifies the Name of the Private Service Connection."
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "Specifies the name of the private DNS zone group."
}

variable "private_dns_zone_ids" {
  type        = list
  description = "Specifies a list of private DNS zones IDs"
  default     = []
}
