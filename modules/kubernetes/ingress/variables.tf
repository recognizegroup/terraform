variable "name" {
  type        = string
  description = "The name of the ingress"
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the application to"
}

variable "annotations" {
  type        = map(string)
  description = "Annotations for the ingress"
  default     = {}
}

variable "rules" {
  type = list(object({
    host = string
    paths = list(object({
      service = string
      port    = number
      path    = string
    }))
  }))
  description = "The rules for the ingress"
  default     = []
}

variable "config_path" {
  type        = string
  description = "The path to the config file"
  default = "~/.kube/config"
}
