variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Name of the web app."
}

variable "service_plan_id" {
  type        = string
  description = "ID of the service plan."
}

variable "always_on" {
  type        = bool
  description = "Indicates whether the Web App should be always on."
  default     = true
}

variable "app_settings" {
  type        = map(any)
  description = "The app settings of this web app."
  default     = {}
}

variable "dotnet_version" {
  type        = string
  description = "The .NET framework version of this web app."
  default     = null
}

variable "docker_image_name" {
  type        = string
  description = "Docker image name and tag for the web app."
  default     = null
}

# Deprecated in favor of docker_image_name
# TODO: Remove deprecated variable in next major version
variable "docker_image" {
  type        = string
  description = "(Deprecated) Docker image for the web app."
  default     = null
}

# Use workaround as described in https://github.com/hashicorp/terraform/issues/25609#issuecomment-1057614400
locals {
  # tflint-ignore: terraform_unused_declarations
  validate_docker_image = (var.docker_image != null && var.docker_image_name != null) ? tobool("Both docker_image and docker_image_name are set. Please only set docker_image_name.") : true
}

# Deprecated in favor of docker_image_name
# TODO: Remove deprecated variable in next major version
variable "docker_image_tag" {
  type        = string
  description = "(Deprecated) Docker image tag for the web app."
  default     = null
}

# Use workaround as described in https://github.com/hashicorp/terraform/issues/25609#issuecomment-1057614400
locals {
  # tflint-ignore: terraform_unused_declarations
  validate_docker_image_tag = (var.docker_image_tag != null && var.docker_image_name != null) ? tobool("Both docker_image_tag and docker_image_name are set. Please only set docker_image_name.") : true
}

variable "websockets_enabled" {
  type        = bool
  description = "Indicates whether websockets are enabled within this web app."
  default     = true
}

variable "health_check_path" {
  type        = string
  description = "The health check path to be pinged by web app."
  default     = null
}

variable "integration_subnet_id" {
  type        = string
  description = "The ID of the integration subnet to enable virtual network integration."
  default     = null
}

variable "private_subnet_id" {
  type        = string
  description = "The ID of the subnet from which private IP addresses will be allocated for the Private Endpoint."
  default     = null
}

variable "custom_domains" {
  type        = set(string)
  description = "Define custom domains attached to this web app."
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

variable "use_32_bit_worker" {
  type        = bool
  description = "Should the Web App run in 32 bit mode, rather than 64 bit mode?"
  default     = false
}

variable "ftps_state" {
  type        = string
  description = "State of FTP / FTPS service for this Web App."
  default     = "FtpsOnly"
}

variable "storage_mount" {
  type = object({
    name         = string,
    type         = string,
    account_name = string,
    share_name   = string,
    access_key   = string
    mount_path   = string
  })
  description = "Storage container or share to be mount within web app instance(s). Note that container mounts are read-only."
  default     = null
}
