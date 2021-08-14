# Set variablees 
USER=$(git config user.name)
EMAIL=$(git config user.email)

# generate a private key 
gpg --gen-key
# export the public key
gpg --export --armor $USER --output public.key

az login --tenant qbits.no
az account set --subscription qbits