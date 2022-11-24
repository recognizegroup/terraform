terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
}

#######################################################
##########                API                ##########
#######################################################

resource "azurerm_api_management_api" "api" {
  name                  = lower(replace(var.api_settings.name, " ", "-"))
  description           = var.api_settings.description
  resource_group_name   = var.resource_group_name
  api_management_name   = var.api_management_name
  service_url           = var.api_settings.service_url
  revision              = var.api_settings.revision
  display_name          = var.api_settings.name
  path                  = var.api_settings.basepath
  protocols             = ["https"]
  subscription_required = var.api_settings.subscription_required

  soap_pass_through = var.soap_pass_through

  import {
    content_format = var.api_settings.openapi_file_path != null ? "openapi" : "wsdl"
    content_value  = var.api_settings.openapi_file_path != null ? file(var.api_settings.openapi_file_path) : file(var.api_settings.wsdl_file_path)

    dynamic "wsdl_selector" {
      for_each = var.wsdl_selector != null ? [1] : []
      content {
        service_name  = var.wsdl_selector.service_name
        endpoint_name = var.wsdl_selector.endpoint_name
      }
    }
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
    %{if var.custom_xml_policy_prepend != null}
    ${var.custom_xml_policy_prepend}
    %{endif}


    %{if var.backend_type == "managed-identity"}
    <authentication-managed-identity resource="${var.managed_identity_resource}" output-token-variable-name="msi-access-token" ignore-error="false" />
      <set-header name="Authorization" exists-action="override">
        <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
      </set-header>
    %{endif}
    %{if var.backend_type == "basic-auth"}
    <authentication-basic username="${var.basic_auth_settings.username != null ? var.basic_auth_settings.username : data.azurerm_key_vault_secret.username[0].value}" password="${var.basic_auth_settings.password != null ? var.basic_auth_settings.password : data.azurerm_key_vault_secret.password[0].value}" />
    %{endif}
    %{if var.backend_type == "body-auth"}
    <set-body>@{
        var body = context.Request.Body.As<JObject>();
        %{if var.soap_body_key != null}
        body["${var.soap_body_key}"]["${var.body_auth_settings.username_key}"] = "${data.azurerm_key_vault_secret.body_username[0].value}";
        body["${var.soap_body_key}"]["${var.body_auth_settings.password_key}"] = "${data.azurerm_key_vault_secret.body_password[0].value}";
        %{else}
        body["${var.body_auth_settings.username_key}"] = "${data.azurerm_key_vault_secret.body_username[0].value}";
        body["${var.body_auth_settings.password_key}"] = "${data.azurerm_key_vault_secret.body_password[0].value}";
        %{endif}
        return body.ToString();
        }
    </set-body>
    %{endif}
    %{if var.backend_type == "oauth"}
    <send-request ignore-error="true" timeout="20" response-variable-name="bearerToken" mode="new">
      <set-url>https://login.microsoftonline.com/${var.oauth_settings.tenant_id}/oauth2/v2.0/token</set-url>
      <set-method>POST</set-method>
      <set-header name="Content-Type" exists-action="override">
        <value>application/x-www-form-urlencoded</value>
      </set-header>
      <set-body>@{
        return "client_id=${var.oauth_settings.client_id}&scope=${var.oauth_settings.scope}&client_secret=${var.oauth_settings.client_secret}&grant_type=client_credentials";
        }
      </set-body>
    </send-request>
    <set-header name="Authorization" exists-action="override">
      <value>@("Bearer " + (String)((IResponse)context.Variables["bearerToken"]).Body.As<JObject>()["access_token"])</value>
    </set-header>
    %{endif}
    <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
    %{if var.backend_type == "api-token"}
    <set-header name= "Authorization" exists-action="override">
      %{if var.api_token_settings.prefix != null}
      <value>${var.api_token_settings.prefix} ${var.api_token_settings.token}</value>
      %{else}
      <value>${var.api_token_settings.token}</value>
      %{endif}
    </set-header>
    %{endif}
    %{if var.custom_policy_append != null}
    ${var.custom_policy_append}
    %{endif}
  </inbound>
</policies>
XML
}

######################################################
##########        Basic-auth serets        ###########
######################################################

data "azurerm_key_vault_secret" "username" {
  count        = var.backend_type == "basic-auth" && (var.basic_auth_settings != null ? var.basic_auth_settings.username_secret != null : false) ? 1 : 0
  name         = var.basic_auth_settings.username_secret
  key_vault_id = var.basic_auth_settings.key_vault_id
}

data "azurerm_key_vault_secret" "password" {
  count        = var.backend_type == "basic-auth" && (var.basic_auth_settings != null ? var.basic_auth_settings.password_secret != null : false) ? 1 : 0
  name         = var.basic_auth_settings.password_secret
  key_vault_id = var.basic_auth_settings.key_vault_id
}

######################################################
##########        Body-auth serets        ###########
######################################################

data "azurerm_key_vault_secret" "body_username" {
  count        = var.backend_type == "body-auth" ? 1 : 0
  name         = var.body_auth_settings.username_secret
  key_vault_id = var.body_auth_settings.key_vault_id
}

data "azurerm_key_vault_secret" "body_password" {
  count        = var.backend_type == "body-auth" ? 1 : 0
  name         = var.body_auth_settings.password_secret
  key_vault_id = var.body_auth_settings.key_vault_id
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
