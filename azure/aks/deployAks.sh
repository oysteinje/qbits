#!/bin/bash
AZURE_LOCATION="norwayeast"
AZURE_PREFIX="ystrte"
AZURE_VNET_RESOURCE_GROUP="rg-main"
AZURE_AKS_NAME="aks-qbits"
AZURE_AKS_RESOURCE_GROUP="rg-aks"
AZURE_DNS_ZONE="azure.qbits.no"
AZURE_DNS_ZONE_RESOURCE_GROUP="rg-qbits"
AZURE_SUBSCRIPTION_ID="a83145a3-215b-44a4-9387-a540faaa58e9"
AZURE_VNET="vnet-main"
AZURE_SUBNET="subnet-aks"
AZURE_KUBERNETES_VERSION="1.21.2"
AZURE_AKS_DNS_PREFIX="aks-qbits"
AZURE_TENANT_ID=$(az account show --query "tenantId" -o tsv)
AZURE_KEYVAULT_NAME="kv-main-qbits"

set -o xtrace

# echo "# Register the EnablePodIdentityPreview"
# az feature register --name EnablePodIdentityPreview --namespace Microsoft.ContainerService
# az extension add --name aks-preview
# az extension update --name aks-preview

echo "# Deploy Resource group" 
az group create \
  -l $AZURE_LOCATION \
  -n $AZURE_AKS_RESOURCE_GROUP

echo "# Create Identity for AKS" 
az identity create \
  --name "id-aks" \
  --resource-group $AZURE_AKS_RESOURCE_GROUP \
  --location $AZURE_LOCATION

echo "# Deploy AKS"
az aks create \
  -l $AZURE_LOCATION \
  -n "aks-qbits" \
  -g $AZURE_AKS_RESOURCE_GROUP \
  --assign-identity $(az identity show -g $AZURE_AKS_RESOURCE_GROUP -n "id-aks" --query "id" -o tsv) \
  --network-plugin "azure" \
  --network-policy "calico" \
  --yes \
  --node-count 3 \
  --node-vm-size "Standard_B2s" \
  --service-cidr "172.0.0.0/16" \
  --dns-service-ip "172.0.0.10" \
  --vnet-subnet-id "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${AZURE_VNET_RESOURCE_GROUP}/providers/Microsoft.Network/virtualNetworks/${AZURE_VNET}/subnets/${AZURE_SUBNET}" \
  --no-ssh-key \
  --kubernetes-version $AZURE_KUBERNETES_VERSION \
  --dns-name-prefix $AZURE_AKS_DNS_PREFIX \
  --enable-addons "azure-keyvault-secrets-provider" \
  --enable-secret-rotation

echo "# Deploy Public IP"
az network public-ip create \
  --name "pip-aks" \
  --location $AZURE_LOCATION \
  --resource-group $AZURE_AKS_RESOURCE_GROUP \
  --allocation-method "Static" \
  --dns-name $AZURE_AKS_DNS_PREFIX \
  --zone 1 \
  --sku "Standard" 

echo "# Deploy DNS CNAME"
az network dns record-set cname set-record \
  --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP \
  --zone-name $AZURE_DNS_ZONE \
  --cname $(az network public-ip show -n "pip-aks" -g $AZURE_AKS_RESOURCE_GROUP --query "dnsSettings.fqdn" -o tsv) \
  --record-set-name "ing"


SECRET_AZURE_CONFIG_FILE=$( jq -n \
                  --arg tid "$AZURE_TENANT_ID" \
                  --arg sid "$AZURE_SUBSCRIPTION_ID" \
                  --arg rg "$AZURE_AKS_RESOURCE_GROUP" \
                  --arg mi "true" \
                  '{tenantId: $tid, subscriptionId: $sid, resourceGroup: $rg, useManagedIdentityExtension: $mi}' )

az keyvault secret set \
  --vault-name "$AZURE_KEYVAULT_NAME" \
  --name "external-dns-azure-config-file" \
  --value "$SECRET_AZURE_CONFIG_FILE"


echo "# Create Identity for AKS" 
az identity create \
  --name "id-pods" \
  --resource-group $AZURE_AKS_RESOURCE_GROUP \
  --location $AZURE_LOCATION

####
#echo "# Deploy aks"
#az deployment group create \
#  --name aks \
#  --resource-group $AZURE_RESOURCE_GROUP \
#  --template-file ./aks.bicep


# az network dns record-set cname list \
#   --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP \
#   --zone-name $AZURE_DNS_ZONE \
#   --query "[].name" -o tsv | grep "ing" --quiet || az network dns record-set cname create \
#     --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP \
#     --name "ing" \
#     --zone-name $AZURE_DNS_ZONE
