param location string = resourceGroup().location
param sku string = 'standard'
param tags object
param servicePrefix string
param objectId string

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: '${abbreviations.keyVault}${servicePrefix}'
  location: location
  tags: tags
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: objectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'list'
          ]
        }
      }
    ]
    sku: {
      name: sku
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}
