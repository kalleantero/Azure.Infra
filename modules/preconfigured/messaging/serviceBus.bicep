param location string = resourceGroup().location
param tags object
param servicePrefix string
param resourceToken string
param sku string

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: '${abbreviations.serviceBus}${servicePrefix}-${location}-${resourceToken}'
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    zoneRedundant: false
  }
}

output serviceBusId string = serviceBus.id
