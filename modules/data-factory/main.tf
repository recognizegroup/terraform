terraform {
  required_version = ">=0.13.4"

  required_providers {
    azurerm = ">=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = var.skip_provider_registration
  features {}
}

resource "azurerm_data_factory" "datafactory" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.datafactory_name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "example" {
  name                = "example"
  resource_group_name = var.resource_group_name
  data_factory_name   = var.location
  connection_string   = data.azurerm_storage_account.example.primary_connection_string

}

resource "azurerm_data_factory_linked_service_web" "example" {
  name                = "example"
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.datafactory.name
  authentication_type = "Anonymous"
  url                 = "https://downloads.pdok.nl/kadastralekaart/api/v4_0/dataset"
}

resource "azurerm_data_factory_dataset_http" "example" {
  name                = "example"
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.datafactory.name
  linked_service_name = azurerm_data_factory_linked_service_web.example.name

  relative_url   = "https://downloads.pdok.nl/kadastralekaart/api/v4_0/dataset"
  request_method = "GET"

}
