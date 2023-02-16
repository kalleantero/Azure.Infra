targetScope='resourceGroup'

param tags object
param location string

module keyVault '../../preconfigured/configuration/keyVault.bicep' = {
  name:'keyvault'
  params:{
    servicePrefix: 'sharedcredentials'
    tags: tags
    location: location
    sku: 'Standard'
    objectId: '00000000-0000-0000-0000-000000000000'
  }
}
