terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.22.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

######################################################
##########          API Management          ##########
######################################################

resource "azurerm_api_management" "api_management" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = var.sku
  virtual_network_type = var.virtual_network_type
  public_ip_address_id = var.public_ip_address_id

  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_type == null ? [] : [1]
    content {
      subnet_id = var.subnet_id
    }
  }

  dynamic "policy" {
    for_each = var.xml_policy_file == null ? [] : [1]
    content {
      xml_content = replace(file(var.xml_policy_file), "$NAME", var.name)
    }
  }

  // Should anonymous users be redirected to the sign in page?
  sign_in {
    enabled = false
  }

  // Can users sign up on the development portal?
  sign_up {
    enabled = false
    // HACK: This is just because terms_of_service is required
    terms_of_service {
      consent_required = false
      enabled          = false
      text             = ""
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

######################################################
##########     API Management Logging       ##########
######################################################

resource "azurerm_api_management_logger" "apim_logger" {
  count               = var.api_management_logger_settings != null ? 1 : 0
  name                = var.api_management_logger_settings.name
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = var.resource_group_name
  resource_id         = var.api_management_logger_settings.application_insights_id

  application_insights {
    instrumentation_key = var.api_management_logger_settings.instrumentation_key
  }
}

resource "azurerm_api_management_diagnostic" "apim_diagnostic" {
  count                    = (var.api_management_logger_settings != null && var.azurerm_api_management_diagnostic_settings != null) ? 1 : 0
  identifier               = "applicationinsights"
  resource_group_name      = var.resource_group_name
  api_management_name      = azurerm_api_management.api_management.name
  api_management_logger_id = azurerm_api_management_logger.apim_logger[0].id

  sampling_percentage       = var.azurerm_api_management_diagnostic_settings.sampling_percentage
  always_log_errors         = var.azurerm_api_management_diagnostic_settings.always_log_errors
  log_client_ip             = var.azurerm_api_management_diagnostic_settings.log_client_ip
  verbosity                 = var.azurerm_api_management_diagnostic_settings.verbosity
  http_correlation_protocol = var.azurerm_api_management_diagnostic_settings.http_correlation_protocol

  frontend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  frontend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }

  backend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  backend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }
}

resource "azurerm_monitor_smart_detector_alert_rule" "example" {
  count               = length(var.alert_rules_settings)
  resource_group_name = var.resource_group_name
  name                = var.alert_rules_settings[count.index].name
  severity            = var.alert_rules_settings[count.index].severity
  scope_resource_ids  = var.alert_rules_settings[count.index].scope_ids
  frequency           = var.alert_rules_settings[count.index].frequency
  detector_type       = var.alert_rules_settings[count.index].detector_type

  action_group {
    ids = var.alert_rules_settings[count.index].action_groups
  }
}

######################################################
#############          Azure AD          #############
######################################################

data "azuread_client_config" "current" {}

resource "azuread_application" "application" {
  display_name = var.name
  owners       = concat([data.azuread_client_config.current.object_id], var.owners)

  web {
    redirect_uris = ["${azurerm_api_management.api_management.developer_portal_url}/signin"]

    implicit_grant {
      id_token_issuance_enabled = true
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All
      type = "Role"
    }
  }

  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000" # AAD Graph (legacy)

    resource_access {
      id   = "5778995a-e1bf-45b8-affa-663a9f3f4d04" # Directory.Read.All
      type = "Role"
    }
  }
}

resource "azuread_application_password" "password" {
  application_object_id = azuread_application.application.object_id
}

resource "azurerm_api_management_identity_provider_aad" "identity_provider_aad" {
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.api_management.name
  client_id           = azuread_application.application.application_id
  client_secret       = azuread_application_password.password.value
  allowed_tenants     = var.allowed_tenants
  signin_tenant       = var.signin_tenant
}
