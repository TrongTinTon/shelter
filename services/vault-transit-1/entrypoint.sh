#!/bin/sh
set -e

if [ -f /vault/data/init.txt ]; then
  UNSEAL_KEY=$(grep "Unseal Key 1" /vault/data/init.txt | awk '{print $4}')
  ROOT_TOKEN=$(grep "Initial Root Token" /vault/data/init.txt | awk '{print $4}')

  echo "Unsealing Vault..."
  vault operator unseal "$UNSEAL_KEY"
  echo "Logging in to Vault..."
  vault login "$ROOT_TOKEN"
else
  source /vault/init.sh
fi
