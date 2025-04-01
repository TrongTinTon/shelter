#!/bin/sh
set -e

vault server -config=/vault/config/vault-config.hcl &

VAULT_PID=$!

echo "Waiting for Vault to start..."
for i in $(seq 1 30); do
  if vault status > /dev/null 2>&1; then
    echo "Vault is up!"
    break
  fi
  sleep 1
done

vault operator init

wait "$VAULT_PID"
