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
    objectId: 'd9658e9d-8976-4f2f-98d7-4aff0a501324'
  }
}
