param hubNetwork object = {
  name: 'vnet-main'
  addressPrefix: '10.0.0.0/8'
  subnet1Name: 'main'
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

output subnet1Id string = vnetHub.properties.subnets[0].id