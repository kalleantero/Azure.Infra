targetScope='resourceGroup'

param location string = resourceGroup().location
param tags object
param servicePrefix string
param resourceToken string

module appServicePlan '../../preconfigured/appservice/appServicePlan.bicep' = {
  name: 'appServicePlan-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    sku: 'B1'
    kind: 'app,windows'
    resourceToken: resourceToken
  }
}

module logAnalyticsWorkspace '../../preconfigured/logging/logAnalyticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspace-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
  }
}

module applicationInsightsResources '../../preconfigured/logging/applicationInsights.bicep' = {
  name: 'applicationinsights-resources'
  params: {
    location: location
    tags: tags
    workspaceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
    servicePrefix: servicePrefix
    resourceToken: resourceToken
  }
}

module storageAccount '../../preconfigured/storage/storageAccount.bicep' = {
  name: 'storageAccount-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    storageAccountType: 'Standard_LRS'
  }
}

module azureFunction '../../preconfigured/functions/azureFunction.bicep' = {
  name: 'azureFunction-resources'
  dependsOn:[
    appServicePlan
    logAnalyticsWorkspace
    applicationInsightsResources
    storageAccount
  ]
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    serverfarmId: appServicePlan.outputs.appServicePlanId
    instrumentationKey: applicationInsightsResources.outputs.applicationInsightsInstrumentationKey
  }
}

module serviceBus '../../preconfigured/messaging/serviceBus.bicep' = {
  name: 'serviceBus-resources'
  dependsOn:[
    azureFunction
  ]
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    sku: 'Standard'
  }
}
