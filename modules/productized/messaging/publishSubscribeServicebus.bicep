param location string = resourceGroup().location
param tags object
param servicePrefix string
param resourceToken string

module appServicePlan '../../standardized/appservice/appServicePlan.bicep' = {
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

module logAnalyticsWorkspace '../../standardized/logging/logAnalyticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspace-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
  }
}

module applicationInsightsResources '../../standardized/logging/applicationInsights.bicep' = {
  name: 'applicationinsights-resources'
  params: {
    location: location
    tags: tags
    workspaceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
    servicePrefix: servicePrefix
    resourceToken: resourceToken
  }
}

module storageAccount '../../standardized/storage/storageAccount.bicep' = {
  name: 'storageAccount-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    storageAccountType: 'Standard_LRS'
  }
}

module azureFunction '../../standardized/functions/azureFunction.bicep' = {
  name: 'azureFunction-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    serverfarmId: appServicePlan.outputs.appServicePlanId
    instrumentationKey: applicationInsightsResources.outputs.applicationInsightsInstrumentationKey
  }
}

module serviceBus '../../standardized/messaging/serviceBus.bicep' = {
  name: 'serviceBus-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    sku: 'Standard'
  }
}
