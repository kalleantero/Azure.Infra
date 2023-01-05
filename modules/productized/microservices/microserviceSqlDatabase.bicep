param location string
param tags object
param servicePrefix string
param resourceToken string

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

module appServicePlan '../../standardized/appservice/appServicePlan.bicep' = {
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

module appService '../../standardized/appservice/appService.bicep' = {
  name: 'appService-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    applicationInsightsConnectionString: applicationInsightsResources.outputs.applicationInsightsConnectionString
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    resourceToken: resourceToken
  }
}

module sqlDatabase '../../standardized/data/sqlServer.bicep' = {
  name: 'sqlDatabase-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    resourceToken: resourceToken
    sku: 'Basic'
    administratorLogin: 'sqladmin'
  }
}
