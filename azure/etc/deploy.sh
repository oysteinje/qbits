#!/bin/bash
AZURE_LOCATION="norwayeast"
AZURE_PREFIX="ystrte"
AZURE_RESOURCE_GROUP="rg-main"
AZURE_DNS_ZONE="qbits.no"
AZURE_SUBSCRIPTION_ID="a83145a3-215b-44a4-9387-a540faaa58e9"

echo "# Enable xtrace"
set -o xtrace

echo "Setting subscription. . ."
az account set -s $AZURE_SUBSCRIPTION_ID

echo "# Deploy Resource group" 
az group create \
  -l $AZURE_LOCATION \
  -n $AZURE_RESOURCE_GROUP

echo "# Deploy network"
az deployment group create \
  --name rollout01-$RANDOM \
  --resource-group $AZURE_RESOURCE_GROUP \
  --template-file ./vnet.bicep

echo "# Deploy Key Vault"
az deployment group create \
  --name rollout01-$RANDOM \
  --resource-group $AZURE_RESOURCE_GROUP \
  --template-file ./keyvault.bicep 

echo "# Generate random secret"
az keyvault secret set \
  --vault-name "kv-main-qbits" \
  --name "vm-main-passwd" \
  --value $(dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev)

echo "# Generate storage account"
az deployment group create \
    --name 'storage-deploy' \
    --resource-group $AZURE_RESOURCE_GROUP \
    --template-file storage.bicep

echo "# Get deployment output" 
BLOB_DOWNLOAD_SAS=$(az deployment group show \
  -g $AZURE_RESOURCE_GROUP \
  -n 'storage-deploy' \
  -o tsv \
  --query properties.outputs.allBlobDownloadSAS.value)

BLOB_UPLOAD_SAS=$(az deployment group show \
  -g $AZURE_RESOURCE_GROUP \
  -n 'storage-deploy' \
  -o tsv \
  --query properties.outputs.myContainerUploadSAS.value)

echo "# Upload storage-sas-download to key vault"
az keyvault secret set \
  --vault-name "kv-main-qbits" \
  --name "storage-sas-download" \
  --value $BLOB_DOWNLOAD_SAS

echo "# Upload storage-sas-upload to key vault"
az keyvault secret set \
  --vault-name "kv-main-qbits" \
  --name "storage-sas-upload" \
  --value $BLOB_UPLOAD_SAS

echo "Upload init script to storage"
az storage blob upload \
    --sas-token $BLOB_UPLOAD_SAS \
    --account-name "saqbits" \
    -f "scripts/init.sh" \
    -c "scripts" \
    -n "init.sh"

echo "# Deploy vm-main"
az deployment group create \
  --name rollout01-$RANDOM \
  --resource-group $AZURE_RESOURCE_GROUP \
  --parameters @parameters.json \
  --template-file ./vm.bicep 

# echo "# Deploy DNS"
# az deployment group create \
#     --name dns-rollout-$RANDOM \
#     --resource-group "rg-qbits" \
#     --template-file dns.bicep

# echo "# create empty cname" 
# az network dns record-set cname create \
#   --resource-group $AZURE_RESOURCE_GROUP \
#   --zone-name $AZURE_DNS_ZONE \
#   --name "openvpn.azure"

# echo "# set cname" 
# az network dns record-set cname set-record \
#   --resource-group $AZURE_RESOURCE_GROUP \
#   --zone-name $AZURE_DNS_ZONE \
#   --record-set-name "openvpn.azure" \
#   --cname "backend-$AZURE_PREFIX.$AZURE_LOCATION.cloudapp.azure.com"


# az network vnet-gateway create \
#   -n "gw-main" \
#   -l $AZURE_LOCATION \
#   --public-ip-address "gw-pip-main" \
#   -g $AZURE_RESOURCE_GROUP \
#   --vnet "vnet-main" \
#   --address-prefixes "192.168.0.0/24" \
#   --gateway-type "Vpn" \
#   --sku "Standard" \
#   --vpn-type "RouteBased" \
#   --client-protocol OpenVPN \
#   --root-cert-name root-cert \
#   --no-wait \
#   --root-cert-data "MIIBtTCCAVsCFAp0Ot78ITeZF5Ckk41kzTi5QWgRMAoGCCqGSM49BAMCMF0xCzAJ
# BgNVBAYTAk5PMQ4wDAYDVQQIDAVWaWtlbjENMAsGA1UEBwwET3NsbzEOMAwGA1UE
# CgwFUWJpdHMxDDAKBgNVBAsMA09yZzERMA8GA1UEAwwIcWJpdHMubm8wHhcNMjEx
# MTE5MjIzNDMyWhcNMzExMTE3MjIzNDMyWjBdMQswCQYDVQQGEwJOTzEOMAwGA1UE
# CAwFVmlrZW4xDTALBgNVBAcMBE9zbG8xDjAMBgNVBAoMBVFiaXRzMQwwCgYDVQQL
# DANPcmcxETAPBgNVBAMMCHFiaXRzLm5vMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
# QgAEkbfgMwFH18y6U5Uy903eFnCOpCCTVFS6JlswDS5Ycc2hsoFQVntYZQBkIjTu
# BKLe1aOswVnJbFEziB0q5iN+nzAKBggqhkjOPQQDAgNIADBFAiAFsV6PWCHHarg4
# 6glaoruykfe4DpMHhcBa8dRV41sJ8QIhALtGSErAKKgMeOlBlxvVoNtqRsFySPQW
# CXny8/QacBur"







# echo "# Generate key in Key Vault"
# az keyvault key create \
#   --curve "P-256" \
#   --exportable true \
#   --kty "RSA" \
#   --name "root-key" \
#   --size 4096 \
#   --vault-name "kv-main-qbits"

# echo "# Generate self signed certificate"
# az keyvault certificate create \
#   --vault-name "kv-main" \
#   -n "root-cert" \
#   --subscription $AZURE_SUBSCRIPTION_ID \
#   -p "$(az keyvault certificate get-default-policy)"

