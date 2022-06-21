terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = "=3.10.0"
  }

  backend "azurerm" {}

  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}

// TODO: Refactor when pull request closed https://github.com/hashicorp/terraform-provider-azurerm/pull/16671
resource "azurerm_frontdoor" "frontdoor" {
  name                = var.name
  resource_group_name = var.resource_group_name

  // HACK: Front door instance must always contain the default associated frontend endpoint
  frontend_endpoint {
    name      = "default"
    host_name = "${var.name}.azurefd.net"
  }

  backend_pool_settings {
    backend_pools_send_receive_timeout_seconds   = var.backend_pools_send_receive_timeout_seconds
    enforce_backend_pools_certificate_name_check = var.enforce_backend_pools_certificate_name_check
  }

  dynamic "frontend_endpoint" {
    for_each = {
      for endpoint in var.endpoints :
      endpoint.name => endpoint
    }
    content {
      name                                    = frontend_endpoint.value.name
      host_name                               = frontend_endpoint.value.host_name
      session_affinity_enabled                = frontend_endpoint.value.session_affinity_enabled
      session_affinity_ttl_seconds            = frontend_endpoint.value.session_affinity_ttl_seconds
      web_application_firewall_policy_link_id = frontend_endpoint.value.web_application_firewall_policy_link_id
    }
  }

  dynamic "routing_rule" {
    for_each = {
      for route in var.routes :
      route.name => route
    }
    content {
      name               = routing_rule.value.name
      frontend_endpoints = routing_rule.value.frontend_endpoints
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.patterns_to_match
      enabled            = routing_rule.value.enabled

      dynamic "forwarding_configuration" {
        for_each = routing_rule.value.forwarding_configuration != null ? [1] : []
        content {
          backend_pool_name                     = routing_rule.value.forwarding_configuration.backend_pool_name
          cache_enabled                         = routing_rule.value.forwarding_configuration.cache_enabled
          cache_use_dynamic_compression         = routing_rule.value.forwarding_configuration.cache_use_dynamic_compression
          cache_query_parameter_strip_directive = routing_rule.value.forwarding_configuration.cache_query_parameter_strip_directive
          cache_query_parameters                = routing_rule.value.forwarding_configuration.cache_query_parameters
          cache_duration                        = routing_rule.value.forwarding_configuration.cache_duration
          custom_forwarding_path                = routing_rule.value.forwarding_configuration.custom_forwarding_path
          forwarding_protocol                   = routing_rule.value.forwarding_configuration.forwarding_protocol
        }
      }

      dynamic "redirect_configuration" {
        for_each = routing_rule.value.redirect_configuration != null ? [1] : []
        content {
          redirect_type       = routing_rule.value.redirect_configuration.redirect_type
          redirect_protocol   = routing_rule.value.redirect_configuration.redirect_protocol
          custom_host         = routing_rule.value.redirect_configuration.custom_host
          custom_fragment     = routing_rule.value.redirect_configuration.custom_fragment
          custom_path         = routing_rule.value.redirect_configuration.custom_path
          custom_query_string = routing_rule.value.redirect_configuration.custom_query_string
        }
      }
    }
  }

  dynamic "backend_pool" {
    for_each = {
      for backend_pool in var.backend_pools :
      backend_pool.name => backend_pool
    }
    content {
      name                = backend_pool.value.name
      load_balancing_name = backend_pool.value.load_balancing_name
      health_probe_name   = backend_pool.value.health_probe_name

      dynamic "backend" {
        for_each = {
          for backend in backend_pool.value.backends :
          backend.address => backend
        }
        content {
          address     = backend.value.address
          host_header = backend.value.host_header
          http_port   = backend.value.http_port
          https_port  = backend.value.https_port
          enabled     = backend.value.enabled
          priority    = backend.value.priority
          weight      = backend.value.weight
        }
      }
    }
  }

  dynamic "backend_pool_health_probe" {
    for_each = {
      for probe in var.backend_pool_health_probes :
      probe.name => probe
    }
    content {
      name         = backend_pool_health_probe.value.name
      enabled      = backend_pool_health_probe.value.enabled
      path         = backend_pool_health_probe.value.path
      protocol     = backend_pool_health_probe.value.protocol
      probe_method = backend_pool_health_probe.value.probe_method
    }
  }

  dynamic "backend_pool_load_balancing" {
    for_each = {
      for probe in var.backend_pool_load_balancers :
      probe.name => probe
    }
    content {
      name                            = backend_pool_load_balancing.value.name
      sample_size                     = backend_pool_load_balancing.value.sample_size
      successful_samples_required     = backend_pool_load_balancing.value.successful_samples_required
      additional_latency_milliseconds = backend_pool_load_balancing.value.additional_latency_milliseconds
    }
  }
}

resource "azurerm_frontdoor_custom_https_configuration" "custom_https" {
  for_each = {
    for endpoint in var.endpoints : endpoint.name => endpoint
    if endpoint.custom_https == true
  }
  frontend_endpoint_id              = azurerm_frontdoor.frontdoor.frontend_endpoints[each.value.name]
  custom_https_provisioning_enabled = true

  // TODO: extend when needed, preferably stay with frontdoor-managed certificates for maintability
  custom_https_configuration {
    certificate_source = "FrontDoor"
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_frontdoor.frontdoor.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_frontdoor.frontdoor.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].logs

    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
}
