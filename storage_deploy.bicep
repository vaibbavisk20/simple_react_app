param location string = 'westus2'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'teststorage1'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
