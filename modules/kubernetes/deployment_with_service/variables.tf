variable "name" {
  type        = string
  description = "The name of the application"
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the application to"
}

variable "replicas" {
  type        = number
  description = "The number of replicas to deploy"
}

variable "docker_image" {
  type        = string
  description = "The docker image to deploy"
}

variable "cpu_request" {
  type        = string
  description = "The CPU request for the application"
}

variable "cpu_limit" {
  type        = string
  description = "The CPU limit for the application"
}

variable "memory_request" {
  type        = string
  description = "The memory request for the application"
}

variable "memory_limit" {
  type        = string
  description = "The memory limit for the application"
}

variable "container_port" {
  type        = number
  description = "The port the container listens on"
}

variable "target_port" {
  type        = number
  description = "The port the service forwards to"
}

variable "readiness_probe" {
  type = object({
    path = string
    port = number
  })
  description = "The readiness probe for the application"
  default     = null
}

variable "liveness_probe" {
  type = object({
    path = string
    port = number
  })
  description = "The liveness probe for the application"
  default     = null
}

variable "scaler" {
  type = object({
    type = string
    host = string
    replicas = object({
      min = number
      max = number
    })
  })
  default = null
}

variable "config_path" {
  type        = string
  description = "The path to the config file"
  default = "~/.kube/config"
}
