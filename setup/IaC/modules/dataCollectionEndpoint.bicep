@description('Creates a Data Collection Endpoint for Azure Monitor ingestion')
param location string = resourceGroup().location
param dceNameSuffix string = uniqueString(resourceGroup().id)

var dceName = 'dce-guardrails-${dceNameSuffix}'

resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2023-03-11' = {
  name: dceName
  location: location
  properties: {
    description: 'Data Collection Endpoint for Guardrails telemetry'
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
}

output dceId string = dataCollectionEndpoint.id
output dceEndpoint string = dataCollectionEndpoint.properties.logsIngestion.endpoint
