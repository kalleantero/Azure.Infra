//This Main Bicep Module orchestrates creation of the Azure infrastructure which contains multiple microservices

targetScope='subscription'

param tags object
param location string

var resourceGroupNames = [
  'invoicing'
  'ordering'
  'products'
  'configuration'
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

/*
//Resource group for shared services
module configuration './modules/shared/configuration.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-configuration') 
  name: 'configuration'
    params:{
    location: location
    tags: tags
  }
}*/

//Invoicing Microservice
module invoicing './modules/microservices/invoicing.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-invoicing') 
  name: 'invoicing'
    params:{
    location: location
    tags: tags
  }
}

//Products Microservice
module products './modules/microservices/products.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-products') 
  name: 'products'
    params:{
    location: location
    tags: tags
  }
}

//Ordering Microservice
module ordering './modules/microservices/ordering.bicep' = {
  dependsOn:[
    resourceGroups
  ]
  scope: resourceGroup('rg-ordering') 
  name: 'ordering'
    params:{
    location: location
    tags: tags
  }
}

