param dnszones_azure_qbits_no_name string = 'azure.qbits.no'

resource dnszones_azure_qbits_no_name_resource 'Microsoft.Network/dnszones@2018-05-01' = {
  name: dnszones_azure_qbits_no_name
  location: 'global'
  tags: {
    WorkloadName: 'azure.qbits.no'
    LastDeployedBy: 'oystein'
    DataClassification: 'Non-business'
    Criticality: 'Low'
    OpsCommitment: 'Baseline'
  }
  properties: {
    zoneType: 'Public'
  }
}

resource dnszones_azure_qbits_no_name_openvpn 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  parent: dnszones_azure_qbits_no_name_resource
  name: 'openvpn'
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: 'openvpn-qbits.norwayeast.cloudapp.azure.com'
    }
    targetResource: {}
  }
}
