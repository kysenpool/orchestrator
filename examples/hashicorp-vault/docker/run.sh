#!/bin/bash
VAULT_RETRIES=5
echo "Vault is starting..."
until vault status > /dev/null 2>&1 || [ "$VAULT_RETRIES" -eq 0 ]; do
        echo "Waiting for vault to start...: $((VAULT_RETRIES--))"
        sleep 1
done
echo "Authenticating to vault..."
# After next operation we will work with Vault as ROOT until We change auth(see Testing)
vault login token=vault-plaintext-root-token
echo "Initializing vault..."
vault secrets enable -version=2 -path=my.secrets kv
echo "Adding entries..."
vault kv put my.secrets/dev username=test_user password=test_password
echo "Complete..."


# https://developer.hashicorp.com/vault/tutorials/auth-methods/identity
# Trying to create user with groups
# In that example we will create:
# -User
# -Policies - devops + ssh.keys
# -Userpass type auth (login and password, read manual for context of available methods)


#Policies
#Could be represented as files
vault policy write devops -<<EOF
path "secret/data/devops" {
   capabilities = [ "create", "read", "update", "delete" ]
}
EOF
vault policy write ssh.keys -<<EOF
path "secret/data/ssh.keys" {
   capabilities = [ "create", "read", "update", "delete" ]
}
EOF
vault policy list

#Auth (type: userpass) activation
vault auth enable -path="userpass-devops" userpass

#User creation
vault write auth/userpass-devops/users/lev password="training" policies="devops,ssh.keys"

vault auth list -detailed
vault auth list -format=json | jq -r '.["userpass-devops/"].accessor' > accessor_test.txt
vault write -format=json identity/entity name="lev-s" policies="devops,ssh.keys" \
     metadata=organization="Test Inc." \
     metadata=team="DevOps" \
     | jq -r ".data.id" > entity_id.txt
vault write identity/entity-alias name="lev" \
     canonical_id=$(cat entity_id.txt) \
     mount_accessor=$(cat accessor_test.txt) \
     custom_metadata=account="DevOps Account"
vault read -format=json identity/entity/id/$(cat entity_id.txt) | jq -r ".data"

# Testing
# here we have 2 directories that could be accessed by out user
# secret/devops
# secret/ssh.keys

# In that test we want to check is it possible to store keys and read keys from directory
# Directory could represent one directory with all keys (with unique name)
# Or
# We could create 'directory' for each server for further isolation

vault login -format=json -method=userpass -path=userpass-devops \
    username=lev password=training \
    | jq -r ".auth.client_token" > lev_token.txt


# After that operation root access will be overloaded by VAULT_TOKEN env variable
VAULT_TOKEN=$(cat lev_token.txt) vault kv put secret/devops owner="lev"

# Creating some random ssh keys for testing purposes
ssh-keygen -t rsa -q -f "./id_rsa" -N ""

cat ./id_rsa
cat ./id_rsa.pub

# Writing it to key store in base64 format
vault kv put secret/ssh.keys owner="lev" server1.id_rsa="$(cat ./id_rsa | base64 )" \
 server1.id_rsa.pub="$(cat ./id_rsa.pub | base64 )"


# Reading json from directory secret/ssh.keys .
# Possible formats - raw, json, yaml
# It is possible to use `yq` command for parsing json
echo $(vault kv get -format=json -mount=secret ssh.keys )

# Retrieving data by fieldname, 2 separate requests
# Before storing data is being base64 decoded
ID_RSA=$(vault kv get -field=server1.id_rsa -mount=secret ssh.keys | base64 -d)
ID_RSA_PUB=$(vault kv get -field=server1.id_rsa.pub -mount=secret ssh.keys | base64 -d)

echo $ID_RSA
echo $ID_RSA_PUB

#TBD
#Groups

sleep 900