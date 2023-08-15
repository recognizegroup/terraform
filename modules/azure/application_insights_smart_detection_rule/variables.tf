variable "name" {
  type        = string
  description = "Specifies the name of the application insights smart detection rule."
}

variable "application_insights_id" {
  type        = string
  description = "Specifies the ID of the application insights smart detection rule."
}

variable "enabled" {
  type        = bool
  description = "Specifies whether the application insights smart detection rule is enabled."
  default     = null
}

variable "send_emails_to_subscription_owners" {
  type        = bool
  description = "Specifies whether the application insights smart detection rule sends emails to subscription owners."
  default     = null
}

variable "additional_email_recipients" {
  type        = list(string)
  description = "Specifies the additional email recipients for the application insights smart detection rule."
  default     = null
}
