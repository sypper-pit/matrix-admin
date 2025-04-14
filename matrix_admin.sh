#!/bin/bash

# Settings
URL="http://127.0.0.1:8008"
ACCESS_TOKEN="your_access_token"

# Functions

# 1. Authenticate
authenticate() {
  curl -X POST "${URL}/_matrix/client/v3/login" -d '{
    "type": "m.login.password",
    "user": "'"$1"'",
    "password": "'"$2"'"
  }'
}

# 2. Create user
create_user() {
  curl -X POST --header "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "'"$1"'",
    "password": "'"$2"'",
    "admin": '"$3"'
  }' \
  "${URL}/_synapse/admin/v2/users/@$1:example.com"
}

# 3. List users
list_users() {
  curl --header "Authorization: Bearer $ACCESS_TOKEN" \
  -X GET "${URL}/_synapse/admin/v2/users"
}

# 4. Delete user
delete_user() {
  curl -X DELETE --header "Authorization: Bearer $ACCESS_TOKEN" \
  "${URL}/_synapse/admin/v2/users/@$1:example.com"
}

# 5. Check username availability
check_username() {
  curl -X GET "${URL}/_matrix/client/v3/register/available?username=$1"
}

# 6. Change user password
change_password() {
  curl -X PUT --header "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "password": "'"$2"'"
  }' \
  "${URL}/_synapse/admin/v2/users/@$1:example.com/password"
}

# 7. Toggle user status (deactivate/reactivate)
toggle_user_status() {
  curl -X PUT --header "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"deactivated": '"$2"'}' \
  "${URL}/_synapse/admin/v2/users/@$1:example.com"
}

# 8. Get user info
get_user_info() {
  curl --header "Authorization: Bearer $ACCESS_TOKEN" \
  -X GET "${URL}/_synapse/admin/v2/users/@$1:example.com"
}

# Menu
echo "Select operation:"
echo "1) Authenticate"
echo "2) Create user"
echo "3) List users"
echo "4) Delete user"
echo "5) Check username availability"
echo "6) Change user password"
echo "7) Deactivate/Reactivate user"
echo "8) Get user info"

read -p "Enter choice: " choice

case $choice in
  1)
    read -p "Enter username: " username
    read -sp "Enter password: " password
    authenticate "$username" "$password"
    ;;
  2)
    read -p "Enter new username: " username
    read -sp "Enter password: " password
    read -p "Admin privileges? (true/false): " admin_status
    create_user "$username" "$password" "$admin_status"
    ;;
  3)
    list_users
    ;;
  4)
    read -p "Enter username to delete: " username
    delete_user "$username"
    ;;
  5)
    read -p "Enter username to check: " username
    check_username "$username"
    ;;
  6)
    read -p "Enter username to reset password: " username
    read -sp "Enter new password: " password
    change_password "$username" "$password"
    ;;
  7)
    read -p "Enter username to modify: " username
    read -p "Deactivate user? (true/false): " deactivate_status
    toggle_user_status "$username" "$deactivate_status"
    ;;
  8)
    read -p "Enter username to inspect: " username
    get_user_info "$username"
    ;;
  *)
    echo "Invalid choice"
    ;;
esac

echo # Add newline after output
