#!/bin/sh
set -e

if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "active"; then
  echo "Initializing Docker Swarm..."
  sudo docker swarm init
fi

if sudo docker secret ls | grep -q "transit_token"; then
  echo "Secret 'transit_token' already exists. Skipping creation."
else
  echo "Building vault-transit-1 image..."
  cd vault-transit-1
  sudo docker build -t vault-transit-1:latest .

  echo "Starting vault-transit-1 to generate token..."
  CONTAINER_ID=$(sudo docker run -d \
    -v vault-transit-1-data:/vault/data \
    -e VAULT_ADDR=http://vault-transit-1:8200 \
    --hostname vault-transit-1 \
    vault-transit-1:latest)

  echo "Waiting for vault-transit-1 to initialize..."
  until sudo docker logs $CONTAINER_ID | grep -q "TRANSIT_TOKEN="; do
    sleep 2
  done

  TOKEN=$(sudo docker logs $CONTAINER_ID | grep "TRANSIT_TOKEN=" | tail -1 | cut -d'=' -f2)
  if [ -z "$TOKEN" ]; then
    echo "Error: Could not extract token from logs."
    sudo docker stop $CONTAINER_ID
    exit 1
  fi

  echo "Creating Docker secret 'transit_token'..."
  echo -n "$TOKEN" | sudo docker secret create transit_token -

  sudo docker stop $CONTAINER_ID
  sudo docker rm $CONTAINER_ID

  cd -
fi

echo "Starting full Vault stack..."
sudo docker compose up -d

echo "Vault deployment complete."
