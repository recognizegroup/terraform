variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "topic_name" {
  type        = string
  description = "Name of the topic to be created."
}

variable "topic_type" {
  type        = string
  description = "Type of the topic based on the Resource Type. Possible values Microsoft.AppConfiguration.ConfigurationStores, Microsoft.Communication.CommunicationServices, Microsoft.ContainerRegistry.Registries, Microsoft.Devices.IoTHubs, Microsoft.EventGrid.Domains, Microsoft.EventGrid.Topics, Microsoft.Eventhub.Namespaces, Microsoft.KeyVault.vaults, Microsoft.MachineLearningServices.Workspaces, Microsoft.Maps.Accounts, Microsoft.Media.MediaServices, Microsoft.Resources.ResourceGroups, Microsoft.Resources.Subscriptions, Microsoft.ServiceBus.Namespaces, Microsoft.SignalRService.SignalR, Microsoft.Storage.StorageAccounts, Microsoft.Web.ServerFarms and Microsoft.Web.Sites"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "source_arm_resource_id" {
  type        = string
  description = "The ID of the Event Grid System Topic ARM Source."
}
