param location string = resourceGroup().location
param tags object
param servicePrefix string
param resourceToken string

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${abbreviations.logAnalyticsWorkspace}${servicePrefix}-${location}-${resourceToken}'
  location: location
  tags: tags
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
