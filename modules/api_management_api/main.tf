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

locals {
  openapi_fileset = fileset(path.root, "**/**.yaml")
}

#######################################################
##########                API                ##########
#######################################################

resource "azurerm_api_management_api" "api" {
  for_each            = toset(local.openapi_fileset)
  name                = lower(replace(yamldecode(file(each.key))["info"]["title"], " ", "-"))
  description         = yamldecode(file(each.key))["info"]["description"]
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  service_url         = yamldecode(file(each.key))["servers"][0]["url"]
  revision            = yamldecode(file(each.key))["info"]["x-revision"]
  display_name        = yamldecode(file(each.key))["info"]["title"]
  path                = yamldecode(file(each.key))["x-basePath"]
  protocols           = ["https"]

  import {
    content_format = "openapi"
    content_value  = file(each.key)
  }
}

#######################################################
##########            API Policy             ##########
#######################################################

resource "azurerm_api_management_api_policy" "api_policy" {
  for_each            = toset(local.openapi_fileset)
  api_name            = azurerm_api_management_api.api[each.key].name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    %{if yamldecode(file(each.key))["x-auth"]["frontend"]["type"] == "oidc"}
    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
      <openid-config url="${yamldecode(file(each.key))["x-auth"]["frontend"]["url"]}" />
      <required-claims>
        <claim name="aud">
          <value></value>
        </claim>
      </required-claims>
    </validate-jwt>
    %{endif}
    <base />
    %{if yamldecode(file(each.key))["x-auth"]["backend"]["type"] == "managed-identity"}
    <authentication-managed-identity resource="${yamldecode(file(each.key))["x-auth"]["backend"]["client_id"]}" output-token-variable-name="msi-access-token" ignore-error="false" />
      <set-header name="Authorization" exists-action="override">
        <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
      </set-header>
    %{endif}
    %{if yamldecode(file(each.key))["x-auth"]["backend"]["type"] == "basic-auth"}
    <authentication-basic username="${data.azurerm_key_vault_secret.username[each.key].value}" password="${data.azurerm_key_vault_secret.password[each.key].value}" />
    %{endif}
  </inbound>
</policies>
XML
}

######################################################
##########        Basic-auth serets        ###########
######################################################

data "azurerm_key_vault_secret" "username" {
  for_each = {
    for k, v in toset(local.openapi_fileset) : k => v
    if yamldecode(file(k))["x-auth"]["backend"]["type"] == "basic-auth"
  }
  name         = yamldecode(file(each.key))["x-auth"]["backend"]["username-secret"]
  key_vault_id = yamldecode(file(each.key))["x-auth"]["backend"]["key-vault-id"]
}

data "azurerm_key_vault_secret" "password" {
  for_each = {
    for k, v in toset(local.openapi_fileset) : k => v
    if yamldecode(file(k))["x-auth"]["backend"]["type"] == "basic-auth"
  }
  name         = yamldecode(file(each.key))["x-auth"]["backend"]["password-secret"]
  key_vault_id = yamldecode(file(each.key))["x-auth"]["backend"]["key-vault-id"]
}

######################################################
#############        API products        #############
######################################################

resource "azurerm_api_management_product" "product" {
  for_each              = toset(local.openapi_fileset)
  product_id            = azurerm_api_management_api.api[each.key].name
  api_management_name   = var.api_management_name
  resource_group_name   = var.resource_group_name
  display_name          = azurerm_api_management_api.api[each.key].display_name
  subscription_required = false
  published             = true
}

resource "azurerm_api_management_product_api" "product_api" {
  for_each            = toset(local.openapi_fileset)
  api_name            = azurerm_api_management_api.api[each.key].name
  product_id          = azurerm_api_management_product.product[each.key].product_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_product_group" "product_group" {
  for_each            = toset(local.openapi_fileset)
  product_id          = azurerm_api_management_product.product[each.key].product_id
  group_name          = var.api_management_group_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}

######################################################
###########      OIDC authentication       ###########
######################################################
