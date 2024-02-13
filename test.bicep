param location string = 'East US'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'helloworldstorage'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: 'helloworldcontainer'
  parent: storageAccount
  properties: {
    publicAccess: 'Blob'
  }
}

output message string = 'Hello, World!'
output storageAccountConnectionString string = storageAccount.properties.primaryEndpoints.blob
