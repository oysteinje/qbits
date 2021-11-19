param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {
  name: 'vnet-main'
}

output gwSubnetId string = vnet.properties.subnets[0].id

resource symbolicname 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: 'kv-main-qbits'
  location: location
  tags: {}
  properties: {
    accessPolicies: [
      {
        objectId: '924f04b7-838a-4f91-adcc-eff21ee80214'
        permissions: {
          certificates: [ 
            'backup'
            'create'
            'delete'
            'deleteissuers'
            'get'
            'getissuers'
            'import'
            'list'
            'listissuers'
            'managecontacts'
            'manageissuers'
            'purge'
            'recover'
            'restore'
            'setissuers'
            'update'
          ]
          keys: [
            'backup'
            'create'
            'decrypt'
            'delete'
            'encrypt'
            'get'
            'import'
            'list'
            'purge'
            'recover'
            'restore'
            'sign'
            'unwrapKey'
            'update'
            'verify'
            'wrapKey'
          ]
          secrets: [
            'backup'
            'delete'
            'get'
            'list'
            'purge'
            'recover'
            'restore'
            'set'
          ]
          storage: [
            'backup'
            'delete'
            'deletesas'
            'get'
            'getsas'
            'list'
            'listsas'
            'purge'
            'recover'
            'regeneratekey'
            'restore'
            'set'
            'setsas'
            'update'
          ]
        }
        tenantId: '040886fa-09b0-4e7f-8cad-9e9797dd96a0'
      }
    ]
    createMode: 'default'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: false
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: [
        {
          value: '81.0.163.203'
        }
      ]
      virtualNetworkRules: [
        {
          id: vnet.properties.subnets[0].id
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: '040886fa-09b0-4e7f-8cad-9e9797dd96a0'
  }
}