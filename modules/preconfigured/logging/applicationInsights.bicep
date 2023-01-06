param location string = resourceGroup().location
param tags object
param servicePrefix string
param workspaceId string
param resourceToken string

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${abbreviations.applicationInsights}${servicePrefix}-${location}-${resourceToken}'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceId
  }
}

output applicationInsightsConnectionString string = applicationInsights.properties.ConnectionString
output applicationInsightsId string = applicationInsights.id
output applicationInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey
