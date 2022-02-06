terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.81.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.7.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "azurerm_api_management" "api_management" {
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.api_management_sku

  identity {
    type = "SystemAssigned"
  }
}

data "azuread_client_config" "current" {}

resource "azuread_application" "application" {
  display_name = var.api_management_name
  owners       = concat([data.azuread_client_config.current.object_id], var.api_management_owners)

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
  allowed_tenants     = var.id_provider_allowed_tenants
}
