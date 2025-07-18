terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

# Endpoints
resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoints" {
  for_each = { for endpoint in var.endpoints : endpoint => endpoint }

  name                    = each.value
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

# Custom domains
resource "azurerm_cdn_frontdoor_custom_domain" "fd_custom_domains" {
  for_each            = { for fd_endpoint in azurerm_cdn_frontdoor_endpoint.fd_endpoints : fd_endpoint.name => fd_endpoint }
  
  name                = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  host_name           = each.value.host_name

  tls {
    certificate_type = "ManagedCertificate"
  }
}

# Origin groups
resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_groups" {
  for_each            = { for group in var.origin_groups : group.name => group }

  name                = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = each.value.health_probe.interval_in_seconds
    protocol            = each.value.health_probe.protocol
    path                = each.value.health_probe.path
    request_type        = each.value.health_probe.request_type
  }

  load_balancing { }
}

# Origins
resource "azurerm_cdn_frontdoor_origin" "fd_origins" {
  for_each = {
    for group in var.origin_groups :
        group.name => group.fd_origins[0] # assumes 1 origin per pool (can be expanded)
  }

  name                          = each.key
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_groups[each.key].id
  
  certificate_name_check_enabled = false

  host_name                     = each.value.host_name
  http_port                     = each.value.http_port
  https_port                    = each.value.https_port
  origin_host_header            = each.value.origin_host_header
  priority                      = each.value.priority
  weight                        = each.value.weight
  enabled                       = each.value.enabled
}

# Redirect Rule Set
resource "azurerm_cdn_frontdoor_rule_set" "fd_rs_redirect" {
  name                     = "fdRedirectRuleSet"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

# HTTP to HTTPS Redirect Rule
resource "azurerm_cdn_frontdoor_rule" "fd_rule_http_to_https" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.fd_origin_groups, azurerm_cdn_frontdoor_origin.fd_origins]

  name                      = "FdRuleHttpToHttps"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.fd_rs_redirect.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    url_redirect_action {
      redirect_type        = "PermanentRedirect"
      redirect_protocol    = "Https"
      destination_hostname = ""
    }
  }
}

# Routes (redirects)
resource "azurerm_cdn_frontdoor_route" "fd_redirect_routes" {
  for_each = {
    for route in var.redirect_routes : route.name => route
  }

  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoints[each.value.frontend_endpoint].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_groups[each.value.origin_group_name].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origins[each.value.origin_group_name].id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.fd_rs_redirect.id]
  enabled                       = lookup(each.value, "enabled", true)

  patterns_to_match             = each.value.patterns_to_match
  supported_protocols           = each.value.supported_protocols
  link_to_default_domain        = false
}

# Routes (forwarding)
resource "azurerm_cdn_frontdoor_route" "fd_forwarding_routes" {
  for_each = {
    for route in var.forwarding_routes : route.name => route
  }

  name                            = each.key
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.fd_endpoints[each.value.frontend_endpoint].id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.fd_origin_groups[each.value.origin_group_name].id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.fd_origins[each.value.origin_group_name].id]
  enabled                         = lookup(each.value, "enabled", true)
                                  
  forwarding_protocol             = "HttpsOnly"
  patterns_to_match               = each.value.patterns_to_match
  supported_protocols             = each.value.supported_protocols

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.fd_custom_domains[each.value.frontend_endpoint].id]
  link_to_default_domain          = false
}

# Diagnostic settings
data "azurerm_monitor_diagnostic_categories" "fd_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_monitor_diagnostic_setting" "fd_diagnostics" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_cdn_frontdoor_profile.fd_profile.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.fd_categories[0].log_category_types
    content {
      category = enabled_log.value
      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.fd_categories[0].metrics
    content {
      category = metric.value
      retention_policy {
        enabled = false
      }
    }
  }
}
