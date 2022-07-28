variable "assignments" {
  type = list(object({
    object_id = string,
    role_id   = string
  }))
  description = "The assignments you want to add to an application."
}

variable "application_id" {
  type        = string
  description = "The application ID of the application the assignments are added to."
}
