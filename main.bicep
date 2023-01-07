//This Main Bicep Module orchestrates creation of the Azure infrastructure which contains multiple microservices

targetScope='subscription'

param tags object
param location string
@secure()
param sqlAdminLogin string
@secure()
param sqlAdminPassword string

var resourceGroupNames = [
  'invoicing'
  'ordering'
  'products'
  'config'
]

//This creates resource groups for each microservice
module resourceGroups './modules/preconfigured/resourceGroup/resourceGroup.bicep' = [for resourceGroup in resourceGroupNames: { 
  name: resourceGroup
    params:{
    location: location
    name: 'rg-${resourceGroup}'
    tags: tags
  }
}]

//Shared services
module configuration './modules/core/shared/configuration.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-config') 
  name: 'configuration'
    params:{
    location: location
    tags: tags
  }
}

//Invoicing Microservice
module invoicing './modules/core/microservices/invoicing.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-invoicing') 
  name: 'invoicing'
    params:{
    location: location
    tags: tags
    sqlAdminLogin:sqlAdminLogin
    sqlAdminPassword:sqlAdminPassword
  }
}


//Products Microservice
module products './modules/core/microservices/products.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-products') 
  name: 'products'
    params:{
    location: location
    tags: tags
    sqlAdminLogin:sqlAdminLogin
    sqlAdminPassword:sqlAdminPassword
  }
}

//Ordering Microservice
module ordering './modules/core/microservices/ordering.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-ordering') 
  name: 'ordering'
    params:{
    location: location
    tags: tags
    sqlAdminLogin:sqlAdminLogin
    sqlAdminPassword:sqlAdminPassword
  }
}

