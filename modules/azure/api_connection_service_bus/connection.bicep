@description('location')
param location string = resourceGroup().location

@description('Name of the Service Bus Connection Resource')
param service_bus_connection_name string

@description('Service Bus namespace')
param service_bus_namespace string

resource service_bus_connection_name_resource 'Microsoft.Web/connections@2018-07-01-preview' = {
  location: location
  name: service_bus_connection_name
  kind: 'V1'
  properties: {
    displayName: 'Service Bus'
    api: {
      name: 'servicebus'
      id: '${subscription().id}/providers/Microsoft.Web/locations/${location}/managedApis/servicebus'
    }
    alternativeParameterValues: {}
    parameterValueSet: {
      name: 'managedIdentityAuth'
      values: {
        namespaceEndpoint: {
          value: service_bus_namespace
        }
      }
    }
  }
}
