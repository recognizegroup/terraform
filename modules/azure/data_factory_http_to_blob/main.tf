terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_data_factory" "data_factory" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_resource_group_template_deployment" "service_http" {
  name                = var.service_http_template_name
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_content = <<JSON
{
  "contentVersion": "1.0.0.0",
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "resources" : [
    {
      "name": "${var.data_factory_name}/${var.service_http_name}",
      "type": "Microsoft.DataFactory/factories/linkedservices",
      "apiVersion": "2018-06-01",
      "properties": {
          "type": "HttpServer",
          "typeProperties": {
              "authenticationType": "${var.service_http_authentication_type}",
              "url": "${var.service_http_url}"
          },
          "annotations": []
      }
    }
  ]
}
  JSON
}

resource "azurerm_data_factory_dataset_http" "dataset_http" {
  name                = var.dataset_http_name
  resource_group_name = var.resource_group_name
  data_factory_id     = data.azurerm_data_factory.data_factory.id
  linked_service_name = var.service_http_name
  relative_url        = var.dataset_http_relative_url
  request_method      = var.dataset_http_request_method
  depends_on          = [azurerm_resource_group_template_deployment.service_http]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "service_blob" {
  name                = var.service_blob_name
  resource_group_name = var.resource_group_name
  data_factory_id     = data.azurerm_data_factory.data_factory.id
  connection_string   = data.azurerm_storage_account.storage_account.primary_connection_string
}

resource "azurerm_data_factory_dataset_azure_blob" "dataset_blob" {
  name                = var.dataset_blob_name
  resource_group_name = var.resource_group_name
  data_factory_id     = data.azurerm_data_factory.data_factory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.service_blob.name
  path                = var.storage_container_name
  filename            = var.dataset_blob_filename
}

resource "azurerm_data_factory_trigger_schedule" "schedule" {
  name                = var.data_factory_schedule_name
  data_factory_id     = data.azurerm_data_factory.data_factory.id
  resource_group_name = var.resource_group_name
  pipeline_name       = azurerm_data_factory_pipeline.pipeline.name
  interval            = var.schedule_interval
  frequency           = var.schedule_frequency
}

resource "azurerm_data_factory_pipeline" "pipeline" {
  name                = var.data_factory_pipeline_name
  resource_group_name = var.resource_group_name
  data_factory_id     = data.azurerm_data_factory.data_factory.id

  activities_json = <<JSON
[
  {
    "name": "CopyData",
    "type": "Copy",
    "inputs": [
      {
        "referenceName": "${azurerm_data_factory_dataset_http.dataset_http.name}",
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
