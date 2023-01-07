param location string = resourceGroup().location
param tags object
param servicePrefix string
param resourceToken string
param serverfarmId string
param instrumentationKey string

var storageAccountType = 'Standard_LRS'
var functionWorkerRuntime = 'dotnet'
var abbreviations = loadJsonContent('../../../assets/abbreviations.json')
var functionAppName = '${abbreviations.functionsApp}${servicePrefix}-${location}-${resourceToken}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${abbreviations.storageAccount}${servicePrefix}${location}'
  location: location
  tags: tags
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverfarmId
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~10'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: instrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionWorkerRuntime
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}
