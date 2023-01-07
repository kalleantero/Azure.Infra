param location string = resourceGroup().location
param tags object
param servicePrefix string
param resourceToken string
param sku string
@secure()
param administratorLogin string
@secure()
param administratorLoginPassword string

var abbreviations = loadJsonContent('../../../assets/abbreviations.json')

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: '${abbreviations.sqlServer}${servicePrefix}-${location}-${resourceToken}'
  location: location
  tags: tags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${abbreviations.sqlDatabase}${servicePrefix}-${location}'
  location: location
  tags: tags
  parent: sqlServer
  sku: {
    name: sku
    tier: sku
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Local'
    isLedgerOn: false
  }
}

output sqlServerId string = sqlServer.id
