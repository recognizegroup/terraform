terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.22.0"
    }
  }

  backend "azurerm" {}

  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}

#######################################################
##########                API                ##########
#######################################################

resource "azurerm_api_management_api" "api" {
  name                  = lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))
  description           = yamldecode(file(var.openapi_file_path))["info"]["description"]
  resource_group_name   = var.resource_group_name
  api_management_name   = var.api_management_name
  service_url           = yamldecode(file(var.openapi_file_path))["servers"][0]["url"]
  revision              = yamldecode(file(var.openapi_file_path))["info"]["x-revision"]
  display_name          = yamldecode(file(var.openapi_file_path))["info"]["title"]
  path                  = yamldecode(file(var.openapi_file_path))["x-basePath"]
  protocols             = ["https"]
  subscription_required = var.require_api_subscription

  depends_on = [
    azurerm_api_management_authorization_server.oauth2
  ]
  oauth2_authorization {
    authorization_server_name = "${lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))}-auth"
  }

  import {
    content_format = "openapi"
    content_value  = file(var.openapi_file_path)
  }
}

######################################################
###########         API Diagnostics        ###########
######################################################

resource "azurerm_api_management_api_diagnostic" "api_diagnostic" {
  count = var.api_management_logger_id != null ? 1 : 0

  identifier               = "applicationinsights"
  resource_group_name      = var.resource_group_name
  api_management_name      = var.api_management_name
  api_name                 = azurerm_api_management_api.api.name
  api_management_logger_id = var.api_management_logger_id

  sampling_percentage       = var.api_diagnostic_settings.sampling_percentage
  always_log_errors         = var.api_diagnostic_settings.always_log_errors
  log_client_ip             = var.api_diagnostic_settings.log_client_ip
  verbosity                 = var.api_diagnostic_settings.verbosity
  http_correlation_protocol = var.api_diagnostic_settings.http_correlation_protocol

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

#######################################################
##########            API Policy             ##########
#######################################################

resource "azurerm_api_management_api_policy" "api_policy" {
  api_name            = azurerm_api_management_api.api.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
  <base />
    %{if yamldecode(file(var.openapi_file_path))["x-auth"]["frontend"]["type"] == "aad"}
            <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
            <openid-config url="${yamldecode(file(var.openapi_file_path))["x-auth"]["frontend"]["openid_url"]}" />
            <required-claims> 
                <claim name="aud" match="any">
                    <value>${azuread_application.application.application_id}</value>
                </claim>
                <claim name="iss" match="any">
                  <value>${yamldecode(file(var.openapi_file_path))["x-auth"]["frontend"]["issuer"]}</value>
                </claim>
            </required-claims>
        </validate-jwt>
    %{endif}
    %{if yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["type"] == "managed-identity"}
    <authentication-managed-identity resource="${yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["client_id"]}" output-token-variable-name="msi-access-token" ignore-error="false" />
      <set-header name="Authorization" exists-action="override">
        <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
      </set-header>
    %{endif}
    %{if yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["type"] == "basic-auth"}
    <authentication-basic username="${data.azurerm_key_vault_secret.username[0].value}" password="${data.azurerm_key_vault_secret.password[0].value}" />
    %{endif}
  </inbound>
</policies>
XML
}

######################################################
##########        Basic-auth serets        ###########
######################################################

data "azurerm_key_vault_secret" "username" {
  count        = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["type"] == "basic-auth" ? 1 : 0
  name         = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["username-secret"]
  key_vault_id = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["key-vault-id"]
}

data "azurerm_key_vault_secret" "password" {
  count        = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["type"] == "basic-auth" ? 1 : 0
  name         = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["password-secret"]
  key_vault_id = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["key-vault-id"]
}

######################################################
#############        API products        #############
######################################################
resource "azurerm_api_management_product" "product" {
  product_id            = azurerm_api_management_api.api.name
  api_management_name   = var.api_management_name
  resource_group_name   = var.resource_group_name
  display_name          = azurerm_api_management_api.api.display_name
  subscription_required = true
  published             = true
}

resource "azurerm_api_management_product_api" "product_api" {
  api_name            = azurerm_api_management_api.api.name
  product_id          = azurerm_api_management_product.product.product_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}

######################################################
###########      OIDC authentication       ###########
######################################################

data "azuread_client_config" "current" {}

resource "azuread_application" "application" {
  display_name     = lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))
  owners           = concat([data.azuread_client_config.current.object_id], var.owners)
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = ["api://${lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))}"]

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Default user access to API"
      admin_consent_display_name = "Default"
      enabled                    = true
      id                         = random_uuid.oath2_uuid.result
      type                       = "Admin"
      user_consent_description   = "Default user access to API"
      user_consent_display_name  = "Default"
      value                      = "Default.Oauth"
    }
  }
  app_role {
    allowed_member_types = ["Application", "User"]
    description          = "Default application app role"
    display_name         = "Default"
    enabled              = true
    id                   = random_uuid.app_role_uuid.result
    value                = "Default.Access"
  }

  dynamic "web" {
    for_each = yamldecode(file(var.openapi_file_path))["x-auth"]["frontend"]["type"] == "aad" ? [1] : []
    content {
      redirect_uris = ["${var.developer_portal_url}/signin-oauth/code/callback/${lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))}-auth"]
    }
  }
}

resource "azuread_service_principal" "internal" {
  application_id = azuread_application.application.application_id
}

resource "azuread_app_role_assignment" "role_assignment" {
  count               = length(var.object_ids)
  app_role_id         = azuread_application.application.app_role_ids["Default.Access"]
  principal_object_id = var.object_ids[count.index]
  resource_object_id  = azuread_service_principal.internal.object_id
}


resource "azurerm_api_management_authorization_server" "oauth2" {
  count                        = yamldecode(file(var.openapi_file_path))["x-auth"]["frontend"]["type"] == "aad" ? 1 : 0
  name                         = "${lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))}-auth"
  authorization_methods        = ["GET", "POST"]
  api_management_name          = var.api_management_name
  resource_group_name          = var.resource_group_name
  display_name                 = "${lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))}-auth"
  grant_types                  = ["authorizationCode"]
  authorization_endpoint       = var.auth_endpoint != null ? var.auth_endpoint : "https://login.microsoftonline.com/${var.authorization_tenant}/oauth2/v2.0/authorize"
  token_endpoint               = var.token_endpoint != null ? var.token_endpoint : "https://login.microsoftonline.com/${var.authorization_tenant}/oauth2/v2.0/token"
  client_registration_endpoint = var.client_registration_endpoint
  client_id                    = azuread_application.application.application_id
  client_secret                = azuread_application_password.password.value
  bearer_token_sending_methods = ["authorizationHeader"]
  client_authentication_method = ["Body"]
  default_scope                = "api://${lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))}/Default.Oauth"

}

resource "azuread_application_password" "password" {
  application_object_id = azuread_application.application.object_id
}

resource "random_uuid" "oath2_uuid" {}

resource "random_uuid" "app_role_uuid" {}
