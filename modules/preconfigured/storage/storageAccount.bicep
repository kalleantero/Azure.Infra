param location string = resourceGroup().location
param tags object
param servicePrefix string
param resourceToken string
param storageAccountType string = 'Standard_LRS'

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${abbreviations.storageAccount}${servicePrefix}${location}'
  location: location
  tags: tags
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
}

output storageAccountId string = storageAccount.id
