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

# echo "# Deploy network"
# az deployment group create \
#   --name rollout01-${{ env.GITHUB_RUN_NUMBER }} \
#   --resource-group ${{ env.AZURE_RESOURCE_GROUP }} \
#   --template-file ./azure/azure-vnet.bicep

echo "# Deploy Key Vault"
az deployment group create \
  --name rollout01-$RANDOM \
  --resource-group $AZURE_RESOURCE_GROUP \
  --template-file keyvault.bicep

echo "# Generate key in Key Vault"
az keyvault key create \
  --curve "P-256" \
  --exportable true \
  --kty "RSA" \
  --name "root-key" \
  --size 4096 \
  --vault-name "kv-main-qbits"

# echo "# Generate self signed certificate"
# az keyvault certificate create \
#   --vault-name "kv-main" \
#   -n "root-cert" \
#   --subscription $AZURE_SUBSCRIPTION_ID \
#   -p "$(az keyvault certificate get-default-policy)"

