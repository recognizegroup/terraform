terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.36"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.4"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azapi" {

}

provider "null" {

}

locals {
  should_create_app   = var.managed_identity_provider.existing != null ? false : true
  should_assign_group = var.managed_identity_provider.create.group_id != null ? true : false
  identifiers         = concat(local.should_create_app ? ["api://${var.managed_identity_provider.create.application_name}"] : [], var.managed_identity_provider.identifier_uris != null ? var.managed_identity_provider.identifier_uris : [])
  allowed_audiences   = concat(local.identifiers, var.managed_identity_provider.allowed_audiences != null ? var.managed_identity_provider.allowed_audiences : [])
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

  app_settings = merge(var.app_settings, {
    MICROSOFT_PROVIDER_AUTHENTICATION_SECRET = "${local.should_create_app ? azuread_application_password.password[0].value : var.managed_identity_provider.existing.client_secret}"
  })
  site_config {
    always_on              = var.always_on
    vnet_route_all_enabled = var.route_all_outbound_traffic
    use_32_bit_worker      = var.use_32_bit_worker

    dynamic "application_stack" {
      for_each = var.dotnet_version != "" ? [var.dotnet_version] : []
      content {
        dotnet_version = application_stack.value
      }
    }

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        ip_address                = ip_restriction.value.ip_address
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        name                      = ip_restriction.value.name
        priority                  = ip_restriction.value.priority
        action                    = ip_restriction.value.action

        dynamic "headers" {
          for_each = ip_restriction.value.headers

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
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

  /*
   * VNet integration is set by a separate resource 'vnet_integration' below, so this must be ignored, see 'NOTE on regional virtual network integration:' here
   * https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app
   */
  lifecycle {
    ignore_changes = [virtual_network_subnet_id]
  }
}


/*
 * https://github.com/hashicorp/terraform-provider-azurerm/issues/12928 blocked by https://github.com/Azure/azure-rest-api-specs/issues/18888
 *
 * The azurerm_linux_function_app module does not yet support Authentication v2 (v1 only) at the moment. Therefore, we create the function without authentication settings.
 * In this block, we add a Microsoft Active Directory identity provider through the AZ API provider.
 * The default audience check in the token is set to the Application ID, but keep in mind that with a valid oAuth app registration in the tenant (AzureADMyOrg), you can
 * create a valid token with this audience. If you need more security, validate the claim in C# or add Claim rules here.
 */

// Needed to have a trigger that allows recreating some resource every time
resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "azapi_update_resource" "setup_auth_settings" {
  type        = "Microsoft.Web/sites/config@2020-12-01"
  resource_id = "${azurerm_linux_function_app.function_app.id}/config/web"

  depends_on = [
    azurerm_linux_function_app.function_app,
    null_resource.always_run
  ]

  body = jsonencode({
    properties = {
      siteAuthSettingsV2 = {
        globalValidation = {
          excludedPaths               = var.authentication_settings.excluded_paths == null ? [] : var.authentication_settings.excluded_paths,
          require_authentication      = var.authentication_settings.require_authentication == null ? false : var.authentication_settings.require_authentication,
          unauthenticatedClientAction = var.authentication_settings.unauthenticated_action == null ? null : var.authentication_settings.unauthenticated_action
        },
        IdentityProviders = {
          azureActiveDirectory = {
            enabled = true,
            registration = {
              clientId                = "${local.should_create_app ? azuread_application.application[0].application_id : var.managed_identity_provider.existing.client_id}",
              clientSecretSettingName = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
            },
            validation = {
              allowedAudiences = local.allowed_audiences
            }
          }
        }
      }
    }
  })
  lifecycle {
    /* This action should always be replaces since is works under the hood as an api call
    * So it does not really track issues with the function app properly
    */
    replace_triggered_by = [
      null_resource.always_run
    ]
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

resource "azuread_service_principal" "application" {
  count                        = local.should_assign_group ? 1 : 0
  application_id               = azuread_application.application[0].application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_group_member" "registered_app_member" {
  count            = local.should_assign_group ? 1 : 0
  group_object_id  = var.managed_identity_provider.create.group_id
  member_object_id = azuread_service_principal.application[0].object_id
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

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].log_category_types

    content {
      category = enabled_log.value

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
