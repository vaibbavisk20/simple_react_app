param location string = 'westus2'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'storage84e8u5jr'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
