param sqlServerName string = 'vskSqlServer2'
param sqlAdminLogin string = 'azureuser'

@secure()
param sqlAdminPassword string = newGuid()

param sqlDatabaseName string = 'vskSqlDatabase2'
param databaseCollation string = 'SQL_Latin1_General_CP1_CI_AS'
param databaseMaxSizeBytes int = 34359738368 // 32 GB
param location string = 'eastus'
param tags object = {}

param principal_id string
param tenant_id string

resource sqlServer 'Microsoft.Sql/servers@2022-08-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlAdmin 'Microsoft.Sql/servers/administrators@2022-08-01-preview' = {
  name: 'ActiveDirectory'
  parent: sqlServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: 'vsk-newapp-56'
    sid: principal_id
    tenantId: tenant_id
    principalType: 'Application'
  }
}

// resource sqlAadAuth 'Microsoft.Sql/servers/azureADOnlyAuthentications@2022-08-01-preview' = {
//   name: 'Default'
//   parent: sqlServer
//   properties: {
//     azureADOnlyAuthentication: true
//   }
// }

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-08-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  properties: {
    collation: databaseCollation
    maxSizeBytes: databaseMaxSizeBytes
  }
}

resource sqlAllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview' = {
  name: 'AllowAllWindowsAzureIps'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output sqlServerName string = sqlServer.name
output databaseName string = sqlDatabase.name
