variable "name" {
  type        = string
  description = "The name of the pvc"
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the pvc to"
}

variable "access_mode" {
  type        = string
  description = "The access mode of the pvc"
}

variable "size" {
  type        = string
  description = "The storage size of the pvc"
}

variable "storage_class" {
  type        = string
  description = "The storage class of the pvc"
}

variable "config_path" {
  type        = string
  description = "The path to the config file"
  default = "~/.kube/config"
}
