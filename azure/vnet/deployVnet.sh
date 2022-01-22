#!/bin/bash
RG_NAME="rg-main"
LOCATION="norwayeast"

echo "# Deploy Resource Group"
az group create \
	-l $LOCATION \
	-n $RG_NAME

echo "# Deploy VNET"
az deployment group create \
	--name rollout01-$RANDOM \
	--resource-group $RG_NAME \
	--template-file ./vnet.bicep
