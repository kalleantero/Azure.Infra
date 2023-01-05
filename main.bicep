targetScope = 'subscription'

param tags object
param location string

/*-----------------<Invoicing microservice>-----------------*/

resource invoicingResourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
    name: 'rg-invoicing'
    location: location
    tags: tags
}

module invoicingResources './modules/productized/microservices/microserviceSqlDatabase.bicep' = {
    name: 'invoicingResources'
    scope: invoicingResourceGroup
    params: {
        location: location
        tags: tags
        servicePrefix: 'invoicing'
        resourceToken: toLower(uniqueString(subscription().id, 'invoicing', location))
    }
}

/*-----------------</Invoicing microservice>-----------------*/

/*-----------------<Ordering microservice>-----------------*/

resource orderingResourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'rg-ordering'
  location: location
  tags: tags
}

module orderingResources './modules/productized/microservices/microserviceSqlDatabase.bicep' = {
  name: 'orderingResources'
  scope: orderingResourceGroup
  params: {
      location: location
      tags: tags
      servicePrefix: 'ordering'
      resourceToken: toLower(uniqueString(subscription().id, 'ordering', location))
  }
}

module publishSubscribeServicebus './modules/productized/messaging/publishSubscribeServicebus.bicep' = {
  name: 'publishSubscribeServicebus'
  scope: orderingResourceGroup
  params: {
      location: location
      tags: tags
      servicePrefix: 'ordering'
      resourceToken: toLower(uniqueString(subscription().id, 'ordering', location))
  }
}

/*-----------------</Ordering microservice>-----------------*/

/*-----------------<Products microservice>-----------------*/

resource productsResourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'rg-products'
  location: location
  tags: tags
}

module productsResources './modules/productized/microservices/microserviceSqlDatabase.bicep' = {
  name: 'productsResources'
  scope: productsResourceGroup
  params: {
      location: location
      tags: tags
      servicePrefix: 'products'
      resourceToken: toLower(uniqueString(subscription().id, 'products', location))
  }
}

/*-----------------</Products microservice>-----------------*/
