param containerName string = 'scripts'

resource mainstorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'saqbits'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}


//create container
resource mainstoragecontainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${mainstorage.name}/default/${containerName}'
  dependsOn: [
    mainstorage
  ]
}

output blobEndpoint string = 'https://saqbits.blob.${environment().suffixes.storage}'
output myContainerBlobEndpoint string = 'https://saqbits.blob.${environment().suffixes.storage}/${containerName}'

//SAS to download all blobs in account
output allBlobDownloadSAS string = listAccountSAS(mainstorage.name, '2021-04-01', {
  signedProtocol: 'https'
  signedResourceTypes: 'sco'
  signedPermission: 'rl'
  signedServices: 'b'
  signedExpiry: '2022-07-01T00:00:00Z'
}).accountSasToken

//SAS to upload blobs to just the mycontainer container.
output myContainerUploadSAS string = listServiceSAS(mainstorage.name,'2021-04-01', {
  canonicalizedResource: '/blob/${mainstorage.name}/${containerName}'
  signedResource: 'c'
  signedProtocol: 'https'
  signedPermission: 'rwl'
  signedServices: 'b'
  signedExpiry: '2022-07-01T00:00:00Z'
}).serviceSasToken
