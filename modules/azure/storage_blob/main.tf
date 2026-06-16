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

  # Use Entra ID (Azure AD) for the Storage data plane instead of Shared Key.
  # Required when the target storage account has shared_access_key_enabled = false.
  storage_use_azuread = var.storage_use_azuread
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = var.remote_file_name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  type                   = var.type
  source                 = var.local_source
}

data "azurerm_storage_account_sas" "sas_token" {
  connection_string = var.storage_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timeadd(timestamp(), "-24h")
  expiry = timeadd(timestamp(), "8760h") // year

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}
