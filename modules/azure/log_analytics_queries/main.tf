terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }

  backend "azurerm" {}
}

provider "random" {
  # Configuration options
}
provider "azurerm" {
  features {}
}

resource "azurerm_log_analytics_query_pack" "query_pack" {
  name                = var.query_pack_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "random_uuid" "uuid" {
  count = var.query_files == null ? 0 : length(var.query_files)
}

resource "azurerm_log_analytics_query_pack_query" "query" {
  count         = var.query_files == null ? 0 : length(var.query_files)
  name          = random_uuid.uuid[count.index].result
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = file(var.query_files[count.index].file_location)
  display_name  = var.query_files[count.index].name

  categories = var.query_files[count.index].categories

  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}
