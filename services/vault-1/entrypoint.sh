#!/bin/sh
set -e

# Read the token from the Docker secret
if [ -f /run/secrets/transit_token ]; then
  TRANSIT_TOKEN=$(cat /run/secrets/transit_token)
  echo "Using transit token from Docker secret."
else
  echo "Error: Transit token not found in /run/secrets/transit_token"
  exit 1
fi

export VAULT_TRANSIT_TOKEN=$TRANSIT_TOKEN
vault server -config=/vault/config/vault-sealed.hcl
