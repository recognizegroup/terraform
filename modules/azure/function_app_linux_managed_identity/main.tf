terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.47"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.33"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.2"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azapi" {

}

locals {
  should_create_app = var.managed_identity_provider.existing != null ? false : true
  identifiers       = concat(local.should_create_app ? ["api://${var.managed_identity_provider.create.application_name}"] : [], var.managed_identity_provider.identifier_uris != null ? var.managed_identity_provider.identifier_uris : [])
  allowed_audiences = concat(local.identifiers, var.managed_identity_provider.allowed_audiences != null ? var.managed_identity_provider.allowed_audiences : [])
}


data "azurerm_client_config" "current" {
}

# Function App

resource "azurerm_linux_function_app" "function_app" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = var.service_plan_id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = var.storage_account_access_key
  functions_extension_version = var.runtime_version

  app_settings = merge(var.app_settings, { MICROSOFT_PROVIDER_AUTHENTICATION_SECRET = "${local.should_create_app ? azuread_application_password.password[0].value : var.managed_identity_provider.existing.client_secret}" })

  site_config {
    always_on              = var.always_on
    vnet_route_all_enabled = var.route_all_outbound_traffic
    ip_restriction         = var.ip_restriction
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  auth_settings_v2 {
    auth_enabled           = true
    require_authentication = var.authetification_settings.require_authentication == null ? false : var.authetification_settings.require_authentication
    unauthenticated_action = var.authetification_settings.unauthenticated_action == null ? null : var.authetification_settings.unauthenticated_action
    excluded_paths         = var.authetification_settings.excluded_paths == null ? [] : var.authetification_settings.excluded_paths

    active_directory_v2 {
      client_id                  = local.should_create_app ? azuread_application.application[0].application_id : var.managed_identity_provider.existing.client_id
      client_secret_setting_name = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
      tenant_auth_endpoint       = "https://login.microsoftonline.com/v2.0/${data.azurerm_client_config.current.tenant_id}/"
      allowed_audiences          = local.allowed_audiences
    }

    login {
      // Bug within terraform module it just requires it
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

# Managed Identity Provider
data "azuread_client_config" "current" {}

resource "azuread_application" "application" {
  count            = local.should_create_app ? 1 : 0
  display_name     = var.managed_identity_provider.create.display_name
  owners           = var.managed_identity_provider.create.owners != null ? concat([data.azuread_client_config.current.object_id], var.managed_identity_provider.create.owners) : [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = local.identifiers

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = var.managed_identity_provider.create.oauth2_settings.admin_consent_description
      admin_consent_display_name = var.managed_identity_provider.create.oauth2_settings.admin_consent_display_name
      enabled                    = var.managed_identity_provider.create.oauth2_settings.enabled
      id                         = random_uuid.oath2_uuid.result
      type                       = var.managed_identity_provider.create.oauth2_settings.type
      user_consent_description   = var.managed_identity_provider.create.oauth2_settings.user_consent_description
      user_consent_display_name  = var.managed_identity_provider.create.oauth2_settings.user_consent_display_name
      value                      = var.managed_identity_provider.create.oauth2_settings.role_value
    }
  }

  web {
    redirect_uris = ["https://${var.name}.azurewebsites.net/.auth/login/aad/callback"]

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

resource "azuread_application_password" "password" {
  count                 = local.should_create_app ? 1 : 0
  application_object_id = azuread_application.application[0].object_id
}

resource "random_uuid" "oath2_uuid" {}

# VNet integration

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_linux_function_app.function_app.id
  subnet_id      = var.integration_subnet_id
}

# Logging and analytics

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_linux_function_app.function_app.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_linux_function_app.function_app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

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
