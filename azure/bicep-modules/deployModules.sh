RG_NAME="rg-acr"
LOCATION="norwayeast"
ACR_NAME="acrqbits"

set -o xtrace

az group create --name $RG_NAME --location $LOCATION 

az deployment group create --resource-group $RG_NAME --template-file main.bicep --parameters acrName=$ACR_NAME
