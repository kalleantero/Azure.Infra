targetScope='resourceGroup'

param location string
param tags object
param servicePrefix string
param resourceToken string
@secure()
param sqlAdminLogin string
@secure()
param sqlAdminPassword string

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

module appServicePlan '../../preconfigured/appservice/appServicePlan.bicep' = {
  name: 'appServicePlan-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    sku: 'F1'
    kind: 'app,windows'
    resourceToken: resourceToken
  }
}

module appService '../../preconfigured/appservice/appService.bicep' = {
  name: 'appService-resources'
  dependsOn:[
    appServicePlan
    applicationInsightsResources
    logAnalyticsWorkspace
  ]
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    applicationInsightsConnectionString: applicationInsightsResources.outputs.applicationInsightsConnectionString
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    resourceToken: resourceToken
  }
}

module sqlDatabase '../../preconfigured/data/sqlServerAndDatabase.bicep' = {
  name: 'sqlDatabase-resources'
  dependsOn:[
    appService
  ]
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    sku: 'Basic'
    administratorLogin: sqlAdminLogin
    administratorLoginPassword:  sqlAdminPassword
  }
}
