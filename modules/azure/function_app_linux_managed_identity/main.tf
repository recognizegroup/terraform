terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.26.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.29.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  should_create_app = var.managed_identity_provider.existing != null ? false : true
}


resource "azurerm_linux_function_app" "function_app" {
  count                      = var.linux_app == true ? 1 : 0
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  app_settings = var.app_settings

  site_config {
    always_on              = var.always_on
    vnet_route_all_enabled = var.route_all_outbound_traffic
    ip_restriction         = var.ip_restriction
  }

  auth_settings {
    enabled = true
    active_directory {
      client_id         = local.should_create_app ? azuread_application.application[0].application_id : var.managed_identity_provider.existing.client_id
      client_secret     = local.should_create_app ? azuread_application_password.password[0].value : var.managed_identity_provider.existing.client_secret
      allowed_audiences = var.managed_identity_provider.allowed_clients
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_windows_function_app" "function_app" {
  count                      = var.linux_app == false ? 1 : 0
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  app_settings = var.app_settings

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
  identifier_uris  = var.managed_identity_provider.create.identifies_uris != null ? var.managed_identity_provider.create.identifies_uris : ["api://${var.managed_identity_provider.create.application_name}"]

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
  app_service_id = var.linux_app ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
  subnet_id      = var.integration_subnet_id
}

# Logging and analytics

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = var.linux_app ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = var.linux_app ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
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
