#!/bin/bash
# This script registers the MySQL Debezium connector by reading its configuration
# from an external JSON file.

echo "Registering MySQL Debezium connector..."
CONFIG_FILE="./config/connector_config.json"
CONNECTOR_NAME="mysql-connector"
CONNECTOR_URL="http://localhost:8083/connectors"  # changed: use container name for Debezium

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Connector configuration file '$CONFIG_FILE' not found!"
    exit 1
fi
echo "Configuration file found..."

# Remove existing connector if it exists
echo "Remove existing connector if it exists"
EXISTING=$(curl -s -o /dev/null -w "%{http_code}" "$CONNECTOR_URL/$CONNECTOR_NAME")
if [ "$EXISTING" = "200" ]; then
  echo "Removing existing connector '$CONNECTOR_NAME'..."
  curl -X DELETE "$CONNECTOR_URL/$CONNECTOR_NAME"
  echo "Connector '$CONNECTOR_NAME' removed."
fi
echo "Connector clean up done"

echo "Registering connector with configuration from '$CONFIG_FILE'..."

curl -i -X POST \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d @"$CONFIG_FILE" \
  "$CONNECTOR_URL"

echo "Connector registered!"
