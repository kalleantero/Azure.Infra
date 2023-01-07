param location string = resourceGroup().location
param tags object
param servicePrefix string
param sku string
param kind string
param resourceToken string

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${abbreviations.appServicePlan}${servicePrefix}-${location}-${resourceToken}'
  location: location
  tags: tags
  kind: kind
  sku: {
    name: sku
  }
}

output appServicePlanId string = appServicePlan.id
