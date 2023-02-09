
@description('Workbook display name')
param workbook_name string

@description('location')
param location string = resourceGroup().location

@description('The unique guid for this workbook instance')
param workbookId string

@description('location of workflow')
param serializedData string

@description('source Id')
param sourceId string
 
resource logic_app 'Microsoft.Insights/workbooks@2021-03-08' = {
  name: workbookId
  location: location
  kind: 'shared'
  properties: {
        displayName: workbook_name
        serializedData: serializedData
        // serializedData: properties.serializedData
        sourceId: sourceId
        category:'workbook'
  }  
}
