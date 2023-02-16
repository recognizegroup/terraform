variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "ec_region" {
  type        = string
  description = "Elastic cloud region."
}

variable "ec_version" {
  type        = string
  description = "Elastic Stack version to use for all the deployment resources."
  default     = "latest"
}

variable "ec_deployment_name" {
  type        = string
  description = "Name of the deployment in Elastic Cloud."
}

variable "ec_deployment_template_id" {
  type        = string
  description = "Deployment template identifier to create the deployment from."
}

variable "elasticsearch_topologies" {
  type        = list(any)
  description = "Can be set multiple times to compose complex topologies."
  default     = []
}

variable "kibana_topologies" {
  type        = list(any)
  description = "Can be set multiple times to compose complex topologies."
  default     = []
}

variable "traffic_filter_name" {
  type        = string
  description = "Name of the traffic filter that contains whitelisted source addresses."
  default     = "Traffic filter"
}

variable "traffic_filter_type" {
  type        = string
  description = "Type of the ruleset. One of 'ip' or 'vpce'"
  default     = "ip"
}

variable "traffic_filter_sources" {
  type        = list(any)
  description = "Type of the ruleset. One of 'ip' or 'vpce'"
  default     = []
}
