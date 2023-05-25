variable "namespace" {
  type        = string
  description = "The namespace to deploy the cronjob to"
}

variable "enabled" {
  type        = bool
  description = "Whether or not to deploy the cronjob"
  default     = true
}

variable "name" {
  type        = string
  description = "The name of the cronjob"
}

variable "schedule" {
  type        = string
  description = "The schedule for the cronjob"
}

variable "starting_deadline_seconds" {
  type        = number
  description = "The deadline in seconds for starting the job if it misses scheduled time for any reason"
  default     = null
}

variable "docker_image" {
  type        = string
  description = "The docker image to use for the cronjob"
}

variable "image_pull_policy" {
  type        = string
  description = "The restart policy for the application"
  default     = null
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

variable "command" {
  type        = list(string)
  description = "The command to run in the cronjob"
  default     = null
}

variable "args" {
  type        = list(string)
  description = "The arguments to pass to the command"
  default     = null
}

variable "restart_policy" {
  type        = string
  description = "The restart policy for the cronjob"
  default     = "Never"
}

variable "config_path" {
  type        = string
  description = "The path to the config file"
  default     = "~/.kube/config"
}
