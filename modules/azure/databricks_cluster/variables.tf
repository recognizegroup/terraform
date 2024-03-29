variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "workspace_url" {
  type        = string
  description = "The url of the databricks workspace."
}

variable "cluster_name" {
  type        = string
  description = "The name of the autoscaling cluster."
}

variable "node_type" {
  type        = string
  description = "The cluster node type id."
  default     = "Standard_F4s"
}

variable "auto_termination_minutes" {
  type        = number
  description = "Idle time after which the cluster shuts down."
  default     = 30
}

variable "autoscaling_min_workers" {
  type        = number
  description = "Minimum number of workers for autoscaling cluster."
  default     = 0
}

variable "autoscaling_max_workers" {
  type        = number
  description = "Maximum number of workers for autoscaling cluster."
  default     = 5
}

variable "spark_version" {
  type        = string
  description = "The spark version to use for the autoscaling cluster."
  default     = "7.6.x-scala2.12"
}

variable "python_location" {
  type        = string
  description = "The python instance on the autoscaling cluster."
  default     = "/databricks/python3/bin/python3"
}

variable "python_packages" {
  type        = list(any)
  description = "The packages to install on the autoscaling cluster."
  default     = []
}

variable "spark_conf" {
  type        = map(any)
  description = "Databricks spark configuration variables."
  default     = {}
}

variable "azure_attributes" {
  type = object({
    availability       = string,
    first_on_demand    = number,
    spot_bid_max_price = number,
  })
  description = "Databricks spark configuration variables."
  default     = null
}

variable "init_script" {
  type        = string
  description = "Script to run when initalizing a databricks job or cluster."
  default     = ""
}

variable "cluster_policy" {
  type        = string
  description = "Default cluster policy."
  default     = ""
}
