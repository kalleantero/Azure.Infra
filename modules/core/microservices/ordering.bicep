//This Bicep Module is responsible for provisioning Ordering microservice

targetScope='resourceGroup'

param tags object
param location string
@secure()
param sqlAdminLogin string
@secure()
param sqlAdminPassword string

var microserviceName = 'ordering'

//Microservice is created with productized Microservice with SQL database module
module microservicesWithSqlDatabase '../../../modules/productized/microservices/microserviceSqlDatabase.bicep' = { 
  name:'microservicesWithSqlDatabase'
  params:{
    location: location
    resourceToken: toLower(uniqueString(subscription().id, microserviceName, location))
    servicePrefix: microserviceName
    tags: tags
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
  }
}

//Microservice also needs publish and subscribe functionalities which are created with productized module
module microservicesWithPubSub '../../../modules/productized/messaging/publishSubscribeServicebus.bicep' = { 
  name:'microservicesWithPubSub'
  dependsOn: [
    microservicesWithSqlDatabase
  ]
  params:{
    location: location
    resourceToken: toLower(uniqueString(subscription().id, microserviceName, location))
    servicePrefix: microserviceName
    tags: tags
  }
}
