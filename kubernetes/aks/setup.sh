AZURE_DNS_PREFIX="qbits"
AZURE_RESOURCE_GROUP="qbits-aks"
AZURE_LOCATION="norwayeast"
AZURE_SUBSCRIPTION="a83145a3-215b-44a4-9387-a540faaa58e9"
OUTPUT_DIR="/tmp/aksengine"

PUBKEY=$(cat ~/.ssh/id_rsa.pub)
# CONTENTS="$(jq --arg pubkey "$PUBKEY" '.properties.linuxProfile.ssh.publicKeys[0].keyData = $pubkey' example.json)"

# echo "${CONTENTS}" > example.json

aks-engine deploy --dns-prefix $AZURE_DNS_PREFIX  \
    --resource-group $AZURE_RESOURCE_GROUP \
    --location $AZURE_LOCATION \
    --api-model example.json \
    --auto-suffix \
    --output-directory /tmp/aksengine \
    --force-overwrite \
    --identity-system azure_ad \
    --subscription-id $AZURE_SUBSCRIPTION \
    --set properties.linuxProfile.ssh.publicKeys[0].keyData=$PUBKEY

KUBECONFIG=_output/contoso-apple-5f776b0d/kubeconfig/kubeconfig.westus2.json kubectl cluster-info

# aks-engine generate --set linuxProfile.adminUsername=myNewUsername,masterProfile.count=3,masterProfile.dnsPrefix=qbits --api-model example.json --output-directory aksEngineOutput