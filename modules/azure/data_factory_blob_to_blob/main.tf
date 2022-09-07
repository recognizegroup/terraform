terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = ">=3.21.1"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

######################################################
##########          Source Dataset          ##########
######################################################

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "source_service" {
  name                = var.source_service_name
  data_factory_id     = var.data_factory_id
  url                 = var.source_storage_account_url
  storage_account_key = var.source_storage_account_key
}

resource "azurerm_data_factory_dataset_binary" "source_dataset" {
  name                = var.source_dataset_name
  data_factory_id     = var.data_factory_id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.source_service.name
  azure_blob_storage_location {
    container = var.source_storage_container_name
  }
}

######################################################
##########          Target Dataset          ##########
######################################################

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "target_service" {
  name                = var.target_service_name
  data_factory_id     = var.data_factory_id
  url                 = var.target_storage_account_url
  storage_account_key = var.target_storage_account_key
}

resource "azurerm_data_factory_dataset_binary" "target_dataset" {
  name                = var.target_dataset_name
  data_factory_id     = var.data_factory_id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.target_service.name
  azure_blob_storage_location {
    container = var.target_storage_container_name
  }
}

######################################################
##########      Schedule and Pipeline       ##########
######################################################

resource "azurerm_data_factory_pipeline" "pipeline" {
  name            = var.pipeline_name
  data_factory_id = var.data_factory_id

  activities_json = <<JSON
[
  {
    "name": "CopyADLSGen2",
    "type": "Copy",
    "inputs": [
      {
        "referenceName": "${azurerm_data_factory_dataset_binary.source_dataset.name}",
        "type": "DatasetReference"
      }
    ],
    "outputs": [
      {
        "referenceName": "${azurerm_data_factory_dataset_binary.target_dataset.name}",
        "type": "DatasetReference"
      }
    ],
    "typeProperties": {
      "source": {
        "type": "BinarySource",
        "storeSettings": {
          "type": "AzureBlobFSReadSettings",
          "recursive": true,
          "wildcardFolderPath": "*",
          "wildcardFileName": "*",
          "deleteFilesAfterCompletion": false
        }
      },
      "sink": {
        "type": "BinarySink",
        "storeSettings": {
          "type": "AzureBlobFSWriteSettings"
        }
      },
      "preserve": [
        "Attributes"
      ]
    }
  }
]
  JSON
}

resource "azurerm_data_factory_trigger_schedule" "schedule" {
  name            = var.schedule_name
  data_factory_id = var.data_factory_id
  pipeline_name   = azurerm_data_factory_pipeline.pipeline.name
  interval        = var.schedule_interval
  frequency       = var.schedule_frequency
}
