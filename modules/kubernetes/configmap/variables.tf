variable "namespace" {
  type        = string
  description = "The namespace to deploy the configmap to"
}

variable "name" {
  type        = string
  description = "The name of the configmap"
}

variable "data" {
  type        = map(string)
  description = "The data to store in the configmap"
}
