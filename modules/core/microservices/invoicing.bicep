//This Bicep Module is responsible for provisioning Invoicing microservice

targetScope='resourceGroup'

param tags object
param location string
@secure()
param sqlAdminLogin string
@secure()
param sqlAdminPassword string

var microserviceName = 'invoicing'

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
