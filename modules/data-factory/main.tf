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

data "azurerm_storage_account" "storage_account" {
  name                = var.datalake_storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_data_factory" "data_factory" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_data_factory_linked_service_web" "service_web" {
  name                = var.service_web_name
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.data_factory.name
  authentication_type = var.service_web_authentication_type
  url                 = var.service_web_url
}

resource "azurerm_data_factory_dataset_http" "dataset_web" {
  name                = var.dataset_web_name
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.data_factory.name
  linked_service_name = azurerm_data_factory_linked_service_web.service_web.name
  relative_url        = var.dataset_web_relative_url
  request_method      = var.dataset_web_request_method
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "service_blob" {
  name                = var.service_blob_name
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.data_factory.name
  connection_string   = data.azurerm_storage_account.storage_account.primary_connection_string
}

resource "azurerm_data_factory_dataset_azure_blob" "dataset_blob" {
  name                = var.dataset_blob_name
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.data_factory.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.service_blob.name
  path                = var.datalake_storage_container_name
  filename            = var.dataset_blob_filename
}

resource "azurerm_data_factory_trigger_schedule" "schedule" {
  name                = var.data_factory_schedule_name
  data_factory_name   = azurerm_data_factory.data_factory.name
  resource_group_name = var.resource_group_name
  pipeline_name       = azurerm_data_factory_pipeline.pipeline.name
  interval            = var.schedule_interval
  frequency           = var.schedule_frequency
}

resource "azurerm_data_factory_pipeline" "pipeline" {
  name                = var.data_factory_pipeline_name
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.data_factory.name
  activities_json     = <<JSON
[
  {
    "name": "CopyData",
    "type": "Copy",
    "inputs": [
      {
        "referenceName": "${azurerm_data_factory_dataset_http.dataset_web.name}",
        "type": "DatasetReference"
      }
    ],
    "outputs": [
      {
        "referenceName": "${azurerm_data_factory_dataset_azure_blob.dataset_blob.name}",
        "type": "DatasetReference"
      }
    ],
    "typeProperties": {
      "source": {
        "type": "RestSource",
        "httpRequestTimeout": "00:01:00"
      },
      "sink": {
        "type": "BinarySink",
        "storeSettings": {
          "type": "AzureBlobStorageWriteSettings"
        }
      }
    }
  }
]
  JSON
}
