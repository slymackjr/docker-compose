#!/bin/sh
# Start Vault in the background
vault server -dev &
echo "Waiting for Vault to start..."
sleep 3

# Install jq if not installed
if ! command -v jq &>/dev/null; then
  echo "jq not found, installing..."
  apk update && apk add jq
  echo "jq installed!"
fi

# Set Vault address and token
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='myroot'

SECRETS_DIR='/vault/config/json'
CONFIG_FILE="$SECRETS_DIR/vaultConfigs.json"

if [ -f "$CONFIG_FILE" ]; then
  echo "Found vaultConfigs.json. Loading combined configs with jq..."
  for service in $(jq -r 'keys[]' "$CONFIG_FILE"); do
    echo "Loading secrets for service: $service"
    data=$(jq -c --arg key "$service" '.[$key]' "$CONFIG_FILE")
    echo "$data" | vault kv put "secret/$service" -
  done
else
  echo "vaultConfigs.json not found. Loading individual JSON files..."
  for file in "$SECRETS_DIR"/*.json; do
    [ "$(basename "$file")" = "vaultConfigs.json" ] && continue
    secret_path=$(basename "$file" .json)
    echo "Loading secrets for: $secret_path"
    vault kv put "secret/$secret_path" @"$file"
  done
fi

echo "Secrets loaded!"

# Keep the container running
wait
