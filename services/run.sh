#!/bin/sh
set -e

if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "active"; then
  echo "Initializing Docker Swarm..."
  sudo docker swarm init
fi

echo "Starting full Vault stack..."
sudo docker stack deploy --compose-file=docker-compose.yml vault

echo "Vault deployment complete."
