param location string = resourceGroup().location
param administratorLogin string
param sku string
param tags object
param servicePrefix string
param resourceToken string

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: 'kv-configuration'
  scope: resourceGroup('rg-configuration')
}

module sqlServer 'sqlServerAndDatabase.bicep' = {
  name: '${abbreviations.sqlServer}${servicePrefix}-${location}-${resourceToken}'
  params: {
    location: location
    tags: tags
    resourceToken: resourceToken
    servicePrefix: servicePrefix
    administratorLogin: administratorLogin
    administratorLoginPassword: kv.getSecret('sqlAdminPassword')
    sku: sku
  }
}

output sqlServerId string = sqlServer.outputs.sqlServerId
