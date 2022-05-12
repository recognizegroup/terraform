terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = "=2.82.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

#######################################################
##########                API                ##########
#######################################################

resource "azurerm_api_management_api" "api" {
  name                = lower(replace(yamldecode(file(var.openapi_file_path))["info"]["title"], " ", "-"))
  description         = yamldecode(file(var.openapi_file_path))["info"]["description"]
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  service_url         = yamldecode(file(var.openapi_file_path))["servers"][0]["url"]
  revision            = yamldecode(file(var.openapi_file_path))["info"]["x-revision"]
  display_name        = yamldecode(file(var.openapi_file_path))["info"]["title"]
  path                = yamldecode(file(var.openapi_file_path))["x-basePath"]
  protocols           = ["https"]

  import {
    content_format = "openapi"
    content_value  = file(var.openapi_file_path)
  }
}

######################################################
###########         API Diagnostics        ###########
######################################################

resource "azurerm_api_management_api_diagnostic" "api_diagnotic" {
  identifier               = "applicationinsights"
  resource_group_name      = var.resource_group_name
  api_management_name      = var.api_management_name
  api_name                 = azurerm_api_management_api.api.name
  api_management_logger_id = var.api_management_logger_id

  always_log_errors        = var.allways_log_errors
  verbosity                = var.verbosity
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
    %{if yamldecode(file(var.openapi_file_path))["x-auth"]["frontend"]["type"] == "oidc"}
    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
      <openid-config url="${yamldecode(file(var.openapi_file_path))["x-auth"]["frontend"]["url"]}" />
      <required-claims>
        <claim name="aud">
          <value></value>
        </claim>
      </required-claims>
    </validate-jwt>
    %{endif}
    <base />
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
  count = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["type"] == "basic-auth" ? 1:0
  name         = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["username-secret"]
  key_vault_id = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["key-vault-id"]
}

data "azurerm_key_vault_secret" "password" {
  count = yamldecode(file(var.openapi_file_path))["x-auth"]["backend"]["type"] == "basic-auth" ? 1:0
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
  subscription_required = false
  published             = true
}

resource "azurerm_api_management_product_api" "product_api" {
  api_name            = azurerm_api_management_api.api.name
  product_id          = azurerm_api_management_product.product.product_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}

# resource "azurerm_api_management_product_group" "product_group" {
#   product_id          = azurerm_api_management_product.product.product_id
#   group_name          = var.api_management_group_name
#   api_management_name = var.api_management_name
#   resource_group_name = var.resource_group_name
# }

######################################################
###########      OIDC authentication       ###########
######################################################

