@description('location')
param location string = resourceGroup().location

@description('Name of the Service Bus Connection Resource')
param log_analytics_workspace_connection_name string

@description('Service Bus namespace')
param log_analytics_workspace_id string

@description('Service Bus namespace')
param log_analytics_workspace_key string

resource log_analytics_workspace_connection 'Microsoft.Web/connections@2018-07-01-preview' = {
  name: log_analytics_workspace_connection_name
  location: location
  kind: 'V1'
  properties: {
    displayName: 'Log Analytics'
    customParameterValues: {}
    parameterValues: {
      username: log_analytics_workspace_id
      password: log_analytics_workspace_key
    }
    api: {
      name: 'azureloganalyticsdatacollector'
      id: '${subscription().id}/providers/Microsoft.Web/locations/${location}/managedApis/azureloganalyticsdatacollector'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: []
  }
}
