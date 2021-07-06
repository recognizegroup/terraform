variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "databricks_workspace_id" {
  type        = string
  description = "The id of the databricks workspace."
}

variable "databricks_sku" {
  type        = string
  description = "The databricks workspace sku."
  default     = "standard"
}

variable "databricks_cluster_name" {
  type        = string
  description = "The name of the autoscaling cluster."
}

variable "databricks_cluster_node_type" {
  type        = string
  description = "The cluster node type id."
  default     = "Standard_F4s"
}

variable "autoscaling_cluster_min_workers" {
  type        = number
  description = "Minimum number of workers for autoscaling cluster."
  default     = 0
}

variable "autoscaling_cluster_max_workers" {
  type        = number
  description = "Maximum number of workers for autoscaling cluster."
  default     = 2
}

variable "databricks_cluster_spark_version" {
  type        = string
  description = "The spark version to use for the autoscaling cluster."
  default     = "7.6.x-scala2.12"
}

variable "databricks_cluster_packages" {
  type        = list
  description = "The packages to install on the autoscaling cluster."
}

variable "databricks_spark_conf" {
  type        = map
  description = "Databricks spark configuration variables."
  default     = {}
}

variable "databricks_init_script" {
  type        = string
  description = "Script to run when initalizing a databricks job or cluster."
  default     = ""
}

variable "databricks_cluster_python_location" {
  type        = string
  description = "The python instance on the autoscaling cluster."
  default     = "/databricks/python3/bin/python3"
}

variable "databricks_cluster_auto_termination" {
  type        = number
  description = "Idle time after which the cluster shuts down."
  default     = 20
}

variable "databricks_groups" {
  type        = map
  description = "Groups and users within Databricks workspace."
}
