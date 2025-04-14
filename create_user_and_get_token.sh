#!/bin/bash

# Configuration
SYNAPSE_PATH="/etc/matrix-synapse"  # Path to Synapse configuration
SERVER_URL="http://localhost:8008"  # Matrix server URL

# Create user using Synapse's built-in utility
create_user() {
  local username=$1
  local password=$2
  local is_admin=$3

  echo "Creating user $username..."
  
  register_new_matrix_user -c "$SYNAPSE_PATH/homeserver.yaml" \
    -u "$username" \
    -p "$password" \
    -a "$is_admin" \
    "$SERVER_URL"
}

# Get access token using curl
get_access_token() {
  local username=$1
  local password=$2

  echo "Getting access token for $username..."
  
  response=$(curl -s -X POST "$SERVER_URL/_matrix/client/v3/login" \
    -H "Content-Type: application/json" \
    -d '{
      "type": "m.login.password",
      "user": "'"$username"'",
      "password": "'"$password"'"
    }')

  if echo "$response" | grep -q '"errcode"'; then
    echo "Error getting access token: $response"
    exit 1
  else
    access_token=$(echo "$response" | grep -o '"access_token":"[^"]*' | cut -d':' -f2 | tr -d '"')
    echo "Access token for $username: $access_token"
  fi
}

# Main script
echo "Matrix User Creation Utility"

read -p "Enter new username: " username
read -sp "Enter password: " password
echo
read -p "Grant admin privileges? (y/n): " admin_choice

if [[ "$admin_choice" == "y" ]]; then
  is_admin="yes"
else
  is_admin="no"
fi

# Create user
create_user "$username" "$password" "$is_admin"

# Get access token
get_access_token "@$username:example.com" "$password"
