variable "roles" {
  type = list(object({
    name = optional(string), //unique Identifier
    object_id = string,
    role_name = string,
    scope     = string,
  }))
  description = "List of role objects to apply roles on users given a certain scope."
}
