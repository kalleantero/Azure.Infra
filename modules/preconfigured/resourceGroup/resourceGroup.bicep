targetScope='subscription'
param location string
param tags object
param name string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: name
  location: location
  tags: tags
}

output resourceGroupName string = resourceGroup.name
