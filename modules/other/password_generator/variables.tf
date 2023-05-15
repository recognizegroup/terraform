variable "password_length" {
  type        = number
  description = "Number of characters of the password."
  default     = 16
}

variable "password_keeper" {
  type        = map(string)
  description = "Random map of strings, when changed the password will rotate."
}

variable "min_lower" {
  type        = number
  description = "Minimum number of lower case characters of the password."
  default     = 0
}

variable "min_upper" {
  type        = number
  description = "Minimum number of upper case characters of the password."
  default     = 0
}

variable "min_numeric" {
  type        = number
  description = "Minimum number of numeric characters of the password."
  default     = 0
}

variable "min_special" {
  type        = number
  description = "Minimum number of special characters of the password."
  default     = 0
}
