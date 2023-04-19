variable "namespace" {
  type        = string
  description = "The namespace to deploy the secret to"
}

variable "name" {
  type        = string
  description = "The name of the secret"
}

variable "data" {
  type        = map(string)
  description = "The data to store in the secret"
}
