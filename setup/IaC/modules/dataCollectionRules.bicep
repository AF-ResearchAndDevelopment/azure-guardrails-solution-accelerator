@description('Creates Data Collection Rules for Guardrails log ingestion')
param location string = resourceGroup().location
param workspaceResourceId string
param dceId string
param dcrNameSuffix string = uniqueString(resourceGroup().id)

var dcrName = 'dcr-guardrails-${dcrNameSuffix}'

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2023-03-11' = {
  name: dcrName
  location: location
  properties: {
    description: 'Data Collection Rule for Guardrails telemetry'
    dataCollectionEndpointId: dceId
    streamDeclarations: {
      'Custom-GuardrailsCompliance': {
        columns: [
          { name: 'TimeGenerated', type: 'datetime' }
          { name: 'ControlName', type: 'string' }
          { name: 'ItemName', type: 'string' }
          { name: 'ComplianceStatus', type: 'string' }
          { name: 'Comments', type: 'string' }
          { name: 'ReportTime', type: 'datetime' }
        ]
      }
      'Custom-GuardrailsComplianceException': {
        columns: [
          { name: 'TimeGenerated', type: 'datetime' }
          { name: 'ControlName', type: 'string' }
          { name: 'ItemName', type: 'string' }
          { name: 'ComplianceStatus', type: 'string' }
          { name: 'Comments', type: 'string' }
          { name: 'ReportTime', type: 'datetime' }
        ]
      }
      'Custom-GRResults': {
        columns: [
          { name: 'TimeGenerated', type: 'datetime' }
          { name: 'ControlName', type: 'string' }
          { name: 'ItemName', type: 'string' }
          { name: 'ComplianceStatus', type: 'string' }
          { name: 'Comments', type: 'string' }
          { name: 'ReportTime', type: 'datetime' }
        ]
      }
      'Custom-GuardrailsUserRaw': {
        columns: [
          { name: 'TimeGenerated', type: 'datetime' }
          { name: 'UserPrincipalName', type: 'string' }
          { name: 'DisplayName', type: 'string' }
          { name: 'UserType', type: 'string' }
          { name: 'AccountEnabled', type: 'boolean' }
        ]
      }
      'Custom-GR2ExternalUsers': {
        columns: [
          { name: 'TimeGenerated', type: 'datetime' }
          { name: 'DisplayName', type: 'string' }
          { name: 'Mail', type: 'string' }
          { name: 'UserType', type: 'string' }
          { name: 'CreatedDate', type: 'datetime' }
          { name: 'Enabled', type: 'boolean' }
        ]
      }
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'guardrails-workspace'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-GuardrailsCompliance']
        destinations: ['guardrails-workspace']
        transformKql: 'source'
        outputStream: 'Custom-GuardrailsCompliance_CL'
      }
      {
        streams: ['Custom-GuardrailsComplianceException']
        destinations: ['guardrails-workspace']
        transformKql: 'source'
        outputStream: 'Custom-GuardrailsComplianceException_CL'
      }
      {
        streams: ['Custom-GRResults']
        destinations: ['guardrails-workspace']
        transformKql: 'source'
        outputStream: 'Custom-GRResults_CL'
      }
      {
        streams: ['Custom-GuardrailsUserRaw']
        destinations: ['guardrails-workspace']
        transformKql: 'source'
        outputStream: 'Custom-GuardrailsUserRaw_CL'
      }
      {
        streams: ['Custom-GR2ExternalUsers']
        destinations: ['guardrails-workspace']
        transformKql: 'source'
        outputStream: 'Custom-GR2ExternalUsers_CL'
      }
    ]
  }
}

output dcrId string = dataCollectionRule.id
output dcrImmutableId string = dataCollectionRule.properties.immutableId
