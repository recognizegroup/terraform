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
  description = "Name of the ADLS gen2 storage account"
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
  description = "The ID of the Subnet from which private IP addresses will be allocated for this Private Endpoint."
}

variable "network_ip_rules" {
  type        = list
  description = "List of public IP or IP ranges in CIDR Format."
  default     = []
}

variable "network_default_action" {
  type        = string
  description = ""
  default     = "Deny"
}

variable "network_subnet_ids" {
  type        = list
  description = "A list of virtual network subnet ids to to secure the storage account."
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}
