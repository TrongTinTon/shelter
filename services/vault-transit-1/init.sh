#!/bin/sh
set -e

source /vault/config/.env
umask 077

vault server -config=/vault/config/vault-config.hcl > /dev/null 2>&1 &
VAULT_PID=$!

echo "Waiting for Vault to start..."
for i in $(seq 1 30); do
  if vault status > /dev/null 2>&1; then
    echo "Vault is up!"
    break
  fi
  sleep 1
done

echo "Initializing Vault..."
vault operator init -key-shares=1 -key-threshold=1 > /vault/data/init.txt

UNSEAL_KEY=$(grep "Unseal Key 1" /vault/data/init.txt | awk '{print $4}')
ROOT_TOKEN=$(grep "Initial Root Token" /vault/data/init.txt | awk '{print $4}')

echo "Unsealing Vault..."
vault operator unseal "$UNSEAL_KEY"
echo "Logging in to Vault..."
vault login "$ROOT_TOKEN"

echo "Enabling transit secrets engine..."
vault secrets enable -path=transit transit
echo "Creating autounseal key..."
vault write --force transit/keys/autounseal
echo "Writing autounseal policy..."
vault policy write autounseal - <<EOF
path "transit/encrypt/autounseal" {
  capabilities = ["update"]
}
path "transit/decrypt/autounseal" {
  capabilities = ["update"]
}
EOF

TRANSIT_TOKEN=$(vault token create -policy=autounseal -period=24h -field=token)

vault secrets enable -path=kv kv
vault kv put kv/auto-unseal/transit-token token="$TRANSIT_TOKEN"
vault policy write unseal-key - <<EOF
path "kv/auto-unseal/transit-token" {
  capabilities = ["read"]
}
EOF

vault auth enable userpass
vault write auth/userpass/users/internal-server \
  password=$UNSEAL_PASSWORD \
  policies=unseal-key

wait "$VAULT_PID"
