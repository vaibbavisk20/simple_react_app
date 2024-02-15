param adminUsername string
param adminPassword securestring
param vmName string
param location string = 'East US'

resource myVM 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', vmName)
        }
      ]
    }
  }
}

resource myNIC 'Microsoft.Network/networkInterfaces@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', vmName)
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vmName, 'default')
          }
        }
      }
    ]
  }
}

resource myPublicIP 'Microsoft.Network/publicIPAddresses@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}
