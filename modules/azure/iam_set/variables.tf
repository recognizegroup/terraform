variable "roles" {
  type = list(object({
    name      = optional(string),
    role_name = string,
    scope     = string,
  }))
  description = "List of role objects to apply roles on users given a certain scope."
}

variable "principals" {
  description = "Map of principals to assign roles to"
  type        = map(string)
}