@description('The name of the Managed Cluster resource.')
param clusterName string = 'qbitsaks'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string = 'qbitsaks'

@minValue(0)
@maxValue(1023)
@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
param osDiskSizeGB int = 32

@minValue(1)
@maxValue(50)
@description('The number of nodes for the cluster.')
param agentCount int = 1

@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_D2s_v3'

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'qbits'

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
// @secure()
param sshRSAPublicKey string = 'AAAAB3ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD13iGyTw2avlStbhlaktIS9xc+R5Oz6Ir+g0o2/Rt4ViEy67LMYnL7YIWxMgkAIVPJJl4qj/I5zTRZkcfcR7Hf2ZcI22oRmWDZIQuqZ+M7A+t1lldz2cB5ELDDJ2M/Vt0V0Nh1uWwccXmLX7lOsVcKyWr31WBGnJ3lv4wPNeh4Vj92/5mZb8YjmgPFAawVcaRzNqpc3MRdcjpKuYutamHigq7jYlxXi5RfPg/efMB63uuVg714MWim8E4jv8Jzw1FKkMlrN5H4aJyotXZtALvN7ipnbrEe+wxf3oFkw630br6J6knWTqslSvtCBIY5jlZPHWjjGeogtdsRNj48o+r7zw0UItdwv5Aoc+0z6LtSpv3xqy7OdZrbARqtWxaB0am2KYNoEqKKecMquu/r0h261jkqh7UMTkqUlyY2Egiv0DE2MF7snffxbSApDCRo8SmQKlIGzW1QTzx3BQmYCJGyoOA2/Bsupvf9ihWRSRVRNDXbYUxuW1z/PWlUPAMIW/M= oystein@shiva'

resource clusterName_resource 'Microsoft.ContainerService/managedClusters@2020-09-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}

output controlPlaneFQDN string =clusterName_resource.properties.fqdn
