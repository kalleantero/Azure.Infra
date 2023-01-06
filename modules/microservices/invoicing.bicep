targetScope='resourceGroup'

param tags object
param location string

var microserviceName = 'invoicing'

module microservicesWithSqlDatabase '../../modules/productized/microservices/microserviceSqlDatabase.bicep' = { 
  name:'microservicesWithSqlDatabase'
  params:{
    location: location
    resourceToken: toLower(uniqueString(subscription().id, microserviceName, location))
    servicePrefix: microserviceName
    tags: tags
  }
}
