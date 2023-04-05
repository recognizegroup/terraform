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

variable "use_existing_service_principal" {
  type        = bool
  default     = false
  description = "When true, any existing service principal linked to the same application will be automatically imported. When false, an import error will be raised for any pre-existing service principal."
}