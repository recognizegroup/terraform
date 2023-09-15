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

variable "ports" {
  type = list(object({
    name        = string
    port        = number
    target_port = number
  }))
  description = "The extra ports the application exposes"
  default     = []
}

variable "readiness_probe" {
  type = object({
    path                  = string
    port                  = number
    initial_delay_seconds = optional(number)
    period_seconds        = optional(number)
    failure_threshold     = optional(number)
    timeout_seconds       = optional(number)
  })
  description = "The readiness probe for the application"
  default     = null
}

variable "liveness_probe" {
  type = object({
    path                  = string
    port                  = number
    initial_delay_seconds = optional(number)
    period_seconds        = optional(number)
    failure_threshold     = optional(number)
    timeout_seconds       = optional(number)
  })
  description = "The liveness probe for the application"
  default     = null
}

variable "scaler" {
  type = object({
    type = optional(string)
    host = optional(string)

    replicas = optional(object({
      min = number
      max = number
    }))
    metrics = optional(object({
      cpu    = number,
      memory = number
    }))
  })
  description = "The scaler for the application"
  default     = null
}

variable "env_secret_refs" {
  type        = list(string)
  description = "The list of secret references to use as environment variables"
  default     = []
}

variable "env_configmap_refs" {
  type        = list(string)
  description = "The list of configmap references to use as environment variables"
  default     = []
}

variable "env" {
  type        = map(string)
  description = "The environment variables for the application"
  default     = {}
}

variable "config_path" {
  type        = string
  description = "The path to the config file"
  default     = "~/.kube/config"
}

variable "volume_mounts" {
  type = list(object({
    claim      = string
    mount_path = string
    sub_path   = string
  }))
  description = "The volume mounts for the application"
  default     = []
}

variable "image_pull_policy" {
  type        = string
  description = "The image pull policy for the application"
  default     = "Always"
}
