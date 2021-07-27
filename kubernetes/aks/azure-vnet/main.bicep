param hubNetwork object = {
  name: 'vnet-hub'
  addressPrefix: '10.0.0.0/20'
  subnet1Name: 'AzureKubernetes'
  subnet1Prefix: '10.0.1.0/24'
}

param location string = resourceGroup().location

resource vnetHub 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: hubNetwork.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubNetwork.addressPrefix
      ]
    }
    subnets: [
      {
        name: hubNetwork.subnet1Name
        properties: {
          addressPrefix: hubNetwork.subnet1Prefix
        }
      }
    ]
  }
}

