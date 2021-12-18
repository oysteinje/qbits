#!/bin/bash
AZURE_LOCATION="norwayeast"
AZURE_VNET_RESOURCE_GROUP="rg-main"
AZURE_AGENTS_RESOURCE_GROUP="rg-agents"
AZURE_DNS_ZONE="qbits.no"
AZURE_SUBSCRIPTION_ID="a83145a3-215b-44a4-9387-a540faaa58e9"
AZURE_VNET="vnet-main"
AZURE_SUBNET="subnet-main"
AZURE_AGENTS_NAME="vmss-agents"

set -o xtrace

echo "# Deploy Resource group" 
az group create \
  -l $AZURE_LOCATION \
  -n $AZURE_AGENTS_RESOURCE_GROUP

echo "# Deploy Agent VMSS"
az vmss create \
  --name $AZURE_AGENTS_NAME \
  --resource-group $AZURE_AGENTS_RESOURCE_GROUP \
  --image UbuntuLTS \
  --vm-sku Standard_B1ls\
  --storage-sku StandardSSD_LRS \
  --authentication-type SSH \
  --instance-count 1 \
  --disable-overprovision \
  --upgrade-policy-mode manual \
  --single-placement-group false \
  --platform-fault-domain-count 1 \
  --vnet-name $AZURE_VNET \
  --subnet $AZURE_SUBNET
  --load-balancer ""
