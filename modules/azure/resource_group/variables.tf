variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "name" {
  type        = string
  description = "Name of the resource group."
}

variable "tags" {
  type        = map(any)
  description = "Optional tags for the resource group."
  default     = null
}

variable "readonly" {
  type        = bool
  default     = false
  description = "Make all elements in this resource group read only. Example use: in production environments to avoid changes on purpose or by mistake."
}

variable "cannotdelete" {
  type        = bool
  default     = false
  description = "Protect all elements in this resource group from deletion. Example use: in production environments to avoid deletes on purpose or by mistake."
}
