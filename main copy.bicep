//This Main Bicep Module orchestrates creation of the Azure infrastructure which contains multiple microservices

targetScope='subscription'

param tags object
param location string

var microserviceNames = [
  'invoicing'
  'ordering'
  'products'
]

//This creates resource groups for each microservice
module resourceGroupsForMicroservices './modules/preconfigured/resourceGroup/resourceGroup.bicep' = [for microserviceName in microserviceNames: { 
  name: microserviceName
    params:{
    location: location
    name: 'rg-${microserviceName}'
    tags: tags
  }
}]

//This arrays contains list of microservices which utilizes productized microservice with SQL database module
var microservicesNamesWithSqlDatabase = [
  'invoicing'
  'products'
]

module microservicesWithSqlDatabase './modules/productized/microservices/microserviceSqlDatabase.bicep' = [for microserviceName in microservicesNamesWithSqlDatabase: { 
  name:'microservicesWithSqlDatabase'
  scope: resourceGroup('rg-${microserviceName}')
  params:{
    location: location
    resourceToken: toLower(uniqueString(subscription().id, microserviceName, location))
    servicePrefix: microserviceName
    tags: tags
  }
}]

//This arrays contains list of microservices which utilizes productized publish & subscribe with Service Bus module
var microservicesNamesWithPublishSubscribeServiceBus = [
  'ordering'
  'invoicing'
]

module microservicesPublishSubscribeServiceBus './modules/productized/messaging/publishSubscribeServicebus.bicep' = [for microserviceName in microservicesNamesWithPublishSubscribeServiceBus: { 
  name:'microservicesPublishSubscribeServiceBus'
  scope: resourceGroup('rg-${microserviceName}')
  params:{
    location: location
    resourceToken: toLower(uniqueString(subscription().id, microserviceName, location))
    servicePrefix: microserviceName
    tags: tags
  }
}]
