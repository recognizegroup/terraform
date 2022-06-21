variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "roles" {
  type        = list(any)
  description = "List of user and group principals with corresponding roles."
}

variable "scope" {
  type        = string
  description = "The scope of the IAM rules. Scope can be set based on a resource and should be the ID of the resource that acts as scope."
}
