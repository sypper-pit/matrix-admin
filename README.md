# Matrix Synapse User Management Script

This repository contains a Bash script for managing users on a Matrix Synapse server. The script uses Synapse Admin API and provides functionality to perform common administrative tasks such as creating users, deleting users, changing passwords, and more.

---

## **Features**
- Authenticate users
- Create new users (with optional admin privileges)
- List all users on the server
- Delete users
- Check username availability
- Change user passwords
- Deactivate or reactivate users
- Retrieve user information

---

## **Requirements**
- Bash shell
- `curl` installed on your system
- Matrix Synapse server running and accessible
- Admin `ACCESS_TOKEN` for the Synapse server

---

## **install JSON**
```
sudo apt install jq     # For Debian/Ubuntu
```
```
sudo yum install jq     # For CentOS/Fedora/RHEL
```
