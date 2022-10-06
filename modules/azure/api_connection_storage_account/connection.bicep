@description('location')
param location string = resourceGroup().location

@description('Name of the Service Bus Connection Resource')
param connectionName string

@description('Storage account name.')
param storage_account_name string

@secure()
@description('Storage account access key.')
param storage_account_access_key string

@description('Api Name')
param apiName string = 'azuretables'

resource storage_account_table_connection 'Microsoft.Web/connections@2018-07-01-preview' = {
  name: connectionName
  location: location
  kind: 'V1'
  properties: {
    displayName: 'Storage Table'
    parameterValues: {
      storageaccount: storage_account_name
      sharedkey: storage_account_access_key
    }
    customParameterValues: {}
    api: {
      name: connectionName
      id: '${subscription().id}/providers/Microsoft.Web/locations/${location}/managedApis/${apiName}'
    }
  }
}
