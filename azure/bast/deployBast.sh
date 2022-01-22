#!/bin/bash

RG_NAME="rg-bast"
LOCATION="norwayeast"

az group create --name $RG_NAME --location $LOCATION 

az vm create \
	--resource-group $RG_NAME \
    --name "vm-bast-qbits" \
    --image UbuntuLTS \
    --assign-identity \
    --admin-username "azureuser" \
    --generate-ssh-keys

az vm extension set \
    --publisher Microsoft.Azure.ActiveDirectory \
    --name AADSSHLoginForLinux \
    --resource-group $RG_NAME \
    --vm-name "vm-bast-qbits"
