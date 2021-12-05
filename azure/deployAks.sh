#!/bin/bash
AZURE_LOCATION="norwayeast"
AZURE_PREFIX="ystrte"
AZURE_RESOURCE_GROUP="rg-aks"
AZURE_DNS_ZONE="qbits.no"
AZURE_SUBSCRIPTION_ID="a83145a3-215b-44a4-9387-a540faaa58e9"


echo "# Deploy Resource group" 
az group create \
  -l $AZURE_LOCATION \
  -n $AZURE_RESOURCE_GROUP

echo "# Deploy aks"
az deployment group create \
  --name aks \
  --resource-group $AZURE_RESOURCE_GROUP \
  --template-file ./aks.bicep


