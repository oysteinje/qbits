#!/bin/bash
AZURE_LOCATION="norwayeast"
AZURE_PREFIX="ystrte"
AZURE_RESOURCE_GROUP="rg-aks"
AZURE_VNET_RESOURCE_GROUP="rg-main"
AZURE_AKS_NAME="aks-qbits"
AZURE_DNS_ZONE="qbits.no"
AZURE_SUBSCRIPTION_ID="a83145a3-215b-44a4-9387-a540faaa58e9"
AZURE_VNET="vnet-main"
AZURE_SUBNET="subnet-aks"
AZURE_KUBERNETES_VERSION="1.21.2"

set -o xtrace

echo "# Deploy Resource group" 
az group create \
  -l $AZURE_LOCATION \
  -n $AZURE_RESOURCE_GROUP

echo "# Deploy AKS"
az aks create \
  -l $AZURE_LOCATION \
  -n "aks-qbits" \
  -g $AZURE_RESOURCE_GROUP \
  --enable-managed-identity \
  --network-plugin "azure" \
  --network-policy "calico" \
  --yes \
  --node-count 1 \
  --node-vm-size "Standard_B2s" \
  --service-cidr "172.0.0.0/16" \
  --dns-service-ip "172.0.0.10" \
  --vnet-subnet-id "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${AZURE_VNET_RESOURCE_GROUP}/providers/Microsoft.Network/virtualNetworks/${AZURE_VNET}/subnets/${AZURE_SUBNET}" \
  --no-ssh-key \
  --kubernetes-version $AZURE_KUBERNETES_VERSION \
  --enable-private-cluster

az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} -n ${AZURE_AKS_NAME} --admin --overwrite-existing

kubectl kustomize $GITHUB_WORKSPACE/gitops/argocd/argocd


#echo "# Deploy aks"
#az deployment group create \
#  --name aks \
#  --resource-group $AZURE_RESOURCE_GROUP \
#  --template-file ./aks.bicep


