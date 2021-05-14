variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "network_security_group_name" {
  type        = string
  description = "Specifies the name of the network security group."
}

variable "security_rules" {
  type        = list
  description = "List of security rules."
}

variable "subnet_ids" {
  type        = list
  description = "List of subnet ids to associate with network security group."
  default     = []
}
