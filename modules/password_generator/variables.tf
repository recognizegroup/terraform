variable "password_length" {
  type        = number
  description = "Number of characters of the password."
  default     = 16
}

variable "password_keeper" {
  type        = map(string)
  description = "Random map of strings, when changed the password will rotate."
}
