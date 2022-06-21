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
  description = "Specifies the name of the Front Door service."
}

variable "endpoints" {
  type = list(object({
    name                                    = string
    host_name                               = string
    session_affinity_enabled                = optional(bool)
    session_affinity_ttl_seconds            = optional(number)
    web_application_firewall_policy_link_id = optional(string)
    custom_https                            = optional(bool)
  }))
  description = "List of frontend_endpoint objects for frontdoor. At least one object is required."
}

variable "routes" {
  type = list(object({
    name               = string
    frontend_endpoints = list(string)
    enabled            = optional(bool)
    accepted_protocols = optional(list(string))
    patterns_to_match  = optional(list(string))
    redirect_configuration = optional(object({
      redirect_type       = string
      redirect_protocol   = optional(string)
      custom_host         = optional(string)
      custom_fragment     = optional(string)
      custom_path         = optional(string)
      custom_query_string = optional(string)
    }))
    forwarding_configuration = optional(object({
      backend_pool_name                     = string
      cache_enabled                         = optional(bool)
      cache_use_dynamic_compression         = optional(bool)
      cache_query_parameter_strip_directive = optional(string)
      cache_query_parameters                = optional(list(string))
      cache_duration                        = optional(string)
      custom_forwarding_path                = optional(string)
      forwarding_protocol                   = optional(string)
    }))
  }))
  description = "A list of routing_rule objects for frontdoor. At least one object is required."
}

variable "backend_pools" {
  type = list(object({
    name                = string
    load_balancing_name = string
    health_probe_name   = string
    backends = list(object({
      address     = string
      host_header = string
      http_port   = number
      https_port  = number
      enabled     = optional(bool)
      priority    = optional(number)
      weight      = optional(number)
    }))
  }))
  description = "A list of backend_pool objects for frontdoor. At least one object is required."
}

variable "backend_pool_health_probes" {
  type = list(object({
    name         = string
    enabled      = optional(string)
    path         = optional(string)
    protocol     = optional(string)
    probe_method = optional(string)
  }))
  description = "A list of backend_pool_health_probe objects for frontdoor. At least one object is required."
}

variable "backend_pool_load_balancers" {
  type = list(object({
    name                            = string
    sample_size                     = optional(number)
    successful_samples_required     = optional(number)
    additional_latency_milliseconds = optional(number)
  }))
  description = "A list of backend_pool_load_balancing objects for frontdoor. At least one object is required."
}
