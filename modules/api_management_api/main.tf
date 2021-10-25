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
