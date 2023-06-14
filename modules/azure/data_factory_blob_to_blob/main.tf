terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
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

# This data factory activity is based on the following documentation:
# https://docs.microsoft.com/en-us/azure/data-factory/solution-template-copy-new-files-lastmodifieddate#how-to-use-this-solution-template

resource "azurerm_data_factory_pipeline" "pipeline" {
  name            = var.pipeline_name
  data_factory_id = var.data_factory_id

  # A manual trigger will copy all exisiting files
  parameters = {
    LastModified_From = "1970-01-01T00:00:00Z",
    LastModified_To   = timestamp()
  }

  activities_json = <<JSON
[
  {
    "name": "SyncADLSGen2",
    "description":"Sync files from adls gen2 to adls gen2 based on last modified date.",
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
          "deleteFilesAfterCompletion": false,
          "modifiedDatetimeStart": {
            "value":"@{pipeline().parameters.LastModified_From}",
            "type":"Expression"
          },
          "modifiedDatetimeEnd": {
            "value":"@{pipeline().parameters.LastModified_To}",
            "type":"Expression"
          }
        }
      },
      "sink": {
        "type": "BinarySink",
        "storeSettings": {
          "type": "AzureBlobFSWriteSettings"
        }
      },
      "preserve": [
        "ACL",
        "Owner",
        "Group"
      ]
    }
  }
]
  JSON
}

resource "azurerm_data_factory_trigger_tumbling_window" "trigger" {
  name            = var.trigger_name
  data_factory_id = var.data_factory_id
  start_time      = var.trigger_start_time
  end_time        = var.trigger_end_time
  frequency       = var.trigger_frequency
  interval        = var.trigger_interval
  max_concurrency = var.trigger_concurrency
  activated       = var.trigger_activated

  retry {
    count    = var.trigger_retry_count
    interval = var.trigger_retry_interval
  }

  pipeline {
    name       = azurerm_data_factory_pipeline.pipeline.name
    parameters = var.trigger_parameters
  }
}
