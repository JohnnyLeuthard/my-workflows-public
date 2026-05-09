# UsageExamples

## Header

| Field | Value |
|-------|-------|
| **File** | UsageExamples.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20usageexamples%20web%20services.htm |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

Common code examples and recipes for CyberArk v12.2 REST API operations.

---

## Example 1: Complete Authentication Flow

```bash
#!/bin/bash

VAULT="https://vault.example.com"
USER="api_user"
PASS="SecurePassword123"

# 1. Logon
TOKEN=$(curl -s -X POST \
  "${VAULT}/api/auth/logon" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"${USER}\",\"password\":\"${PASS}\"}" \
  | grep -o '"CyberArkLogonResult":"[^"]*' | cut -d'"' -f4)

echo "Token: $TOKEN"

# 2. List accounts
curl -s -X GET \
  "${VAULT}/api/Accounts" \
  -H "Authorization: CyberArk ${TOKEN}"

# 3. Logoff
curl -s -X DELETE \
  "${VAULT}/api/auth/logoff" \
  -H "Authorization: CyberArk ${TOKEN}"
```

---

## Example 2: Create Account

```bash
curl -X POST \
  https://vault.example.com/api/Accounts \
  -H "Authorization: CyberArk <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "prod-db-admin",
    "address": "db.prod.com",
    "username": "dbadmin",
    "platformId": "PostgreSQL",
    "safeId": "DatabaseAccounts",
    "password": "InitialPassword123!"
  }'
```

---

## Example 3: Retrieve Account Password

```bash
curl -X POST \
  https://vault.example.com/api/AccountActions \
  -H "Authorization: CyberArk <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "accountID": 123,
    "action": "retrieve",
    "reason": "Scheduled maintenance"
  }'
```

---

## Example 4: List Safes with Pagination

```bash
curl -X GET \
  'https://vault.example.com/api/Safes?limit=50&offset=0' \
  -H "Authorization: CyberArk <token>"
```

---

## Example 5: Update Account Properties

```bash
curl -X PUT \
  https://vault.example.com/api/Accounts/123 \
  -H "Authorization: CyberArk <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "address": "db-new.prod.com",
    "tags": {
      "Environment": "Production",
      "Team": "Database"
    }
  }'
```

---

## Example 6: Python Integration

```python
import requests
import json

vault_url = "https://vault.example.com"
username = "api_user"
password = "SecurePassword123"

# Authenticate
response = requests.post(
    f"{vault_url}/api/auth/logon",
    json={"username": username, "password": password},
    verify=False
)
token = response.json().get("CyberArkLogonResult")

# List accounts
headers = {"Authorization": f"CyberArk {token}"}
response = requests.get(
    f"{vault_url}/api/Accounts?limit=50",
    headers=headers,
    verify=False
)
accounts = response.json()

print(f"Found {len(accounts)} accounts")
for account in accounts:
    print(f"  - {account['name']} on {account['address']}")

# Logoff
requests.delete(
    f"{vault_url}/api/auth/logoff",
    headers=headers,
    verify=False
)
```

---

## Best Practices

1. **Always Logoff**: Close sessions to free resources
2. **Use HTTPS**: Never send credentials over unencrypted connections
3. **Error Handling**: Implement comprehensive error handling for all API calls
4. **Caching**: Cache read responses to reduce API calls
5. **Rate Limiting**: Implement exponential backoff for retries
6. **Audit Logging**: Provide meaningful reasons when retrieving secrets
7. **Certificate Management**: Use certificate-based auth for service accounts

---

**Last Updated**: 2026-05-03
