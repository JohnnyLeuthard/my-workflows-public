# Accounts

## Header

| Field | Value |
|-------|-------|
| **File** | Accounts.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/Accounts |
| **Description** | Create, retrieve, update, and delete vault accounts |
| **Auth Required** | Yes |

---

## Purpose

Core account management endpoint. Create new accounts in the vault, retrieve account details, update account properties, and delete accounts. Accounts represent credentials stored in the vault for managed systems.

---

## Full Path

### List All Accounts
```
GET /api/Accounts
GET /api/Accounts?search=admin&limit=50&offset=0
```

### Get Single Account
```
GET /api/Accounts/{id}
GET /api/Accounts/{AccountID}
```

### Create Account
```
POST /api/Accounts
```

### Update Account
```
PUT /api/Accounts/{id}
```

### Delete Account
```
DELETE /api/Accounts/{id}
```

---

## HTTP Method

### GET /api/Accounts
- **Purpose**: List accounts or retrieve single account details
- **Body**: None
- **Response**: JSON array (list) or object (single)

### POST /api/Accounts
- **Purpose**: Create a new account
- **Body**: JSON object with account properties
- **Response**: JSON object with newly created account including assigned ID

### PUT /api/Accounts/{id}
- **Purpose**: Update existing account properties
- **Body**: JSON object with fields to update
- **Response**: JSON object with updated account

### DELETE /api/Accounts/{id}
- **Purpose**: Delete an account
- **Body**: None
- **Response**: HTTP 204 No Content

---

## Authentication

**Required**: Yes — All operations require valid CyberArk session token

```
Authorization: CyberArk <session_token>
```

**Permissions Required**:
- GET: ReadAccounts permission on target safe
- POST: AddAccounts permission on target safe
- PUT: UpdateAccountProperties permission on account
- DELETE: DeleteAccounts permission on account

---

## Parameters

### URL Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| {id} or {AccountID} | integer | Yes (for single operations) | Numeric account ID | 123456 |

### Query Parameters (for GET list)

| Parameter | Type | Required | Description | Example | Default |
|-----------|------|----------|-------------|---------|---------|
| search | string | No | Search accounts by name, address, or metadata | search=prod-admin | — |
| filter | string | No | Advanced filter (OData format) | filter=name eq 'admin' | — |
| limit | integer | No | Max results per page | limit=50 | 25 |
| offset | integer | No | Pagination offset | offset=0 | 0 |
| sort | string | No | Sort field (name, address, lastUsed) | sort=name | — |

### Headers

| Header | Value | Required | Description |
|--------|-------|----------|-------------|
| Authorization | CyberArk <token> | Yes | Session token |
| Content-Type | application/json | Yes (POST/PUT) | Request format |
| Accept | application/json | No | Response format |

---

## Request Body

### Create/Update Account

```json
{
  "name": "prod-admin-01",
  "address": "prod-server.example.com",
  "username": "administrator",
  "platformId": "WinDomainAccount",
  "safeId": "ProdAccounts",
  "accountType": "domain",
  "autoManagementEnabled": true,
  "password": "InitialPassword123!",
  "passwordNeverExpires": false,
  "tags": {
    "Environment": "Production",
    "CostCenter": "IT-OPS"
  },
  "customProperties": {
    "VendorName": "Internal"
  }
}
```

### Field Descriptions

| Field | Type | Required | Description | Constraints |
|-------|------|----------|-------------|------------|
| name | string | Yes | Display name for account | Max 128 chars, unique per safe |
| address | string | Yes | Target system hostname or IP | Hostname or valid IPv4/IPv6 |
| username | string | Yes | Account username on target system | Platform-dependent format |
| platformId | string | Yes | Platform identifier | Must exist in vault (e.g., WinDomainAccount, UnixSSH) |
| safeId | string | Yes | Safe ID containing account | Must have owner/add permission |
| accountType | string | No | Account classification | local, domain, external |
| autoManagementEnabled | boolean | No | Enable automatic password rotation | Default: false |
| password | string | No (POST) | Secret/password | Required for POST; cannot be used in PUT |
| passwordNeverExpires | boolean | No | Disable automatic expiration | Default: false |
| tags | object | No | Key-value metadata tags | Free-form key-value pairs |
| customProperties | object | No | Additional custom fields | Vault-defined properties |

---

## Response Codes

| Code | Status | Description | Example Response |
|------|--------|-------------|------------------|
| 200 | OK | Successful GET or PUT | `{ "id": 123, "name": "prod-admin", ... }` |
| 201 | Created | Successful POST | `{ "id": 124, "name": "prod-admin-01", ... }` |
| 204 | No Content | Successful DELETE | (empty body) |
| 400 | Bad Request | Invalid parameters or malformed JSON | `{ "ErrorCode": "PASWS003E", ... }` |
| 401 | Unauthorized | Missing or expired token | `{ "ErrorCode": "PASWS002E", ... }` |
| 403 | Forbidden | Insufficient permissions | `{ "ErrorCode": "PASWS008E", ... }` |
| 404 | Not Found | Account or safe not found | `{ "ErrorCode": "PASWS031E", ... }` |
| 409 | Conflict | Account name already exists in safe | `{ "ErrorCode": "PASWS001E", ... }` |
| 500 | Internal Server Error | Vault error | `{ "ErrorCode": "PASWS000E", ... }` |

---

## Notes

- **Pagination**: List endpoints return max 1000 results; use limit/offset for large result sets
- **Secrets**: Account password is never returned in GET responses (except during initial POST creation)
- **Safe Permissions**: User must have appropriate permissions on target safe for all operations
- **Auto-Management**: Once enabled, vault automatically rotates account password per platform rules
- **Deletion**: Deleted accounts cannot be recovered; ensure backups before deletion
- **Caching**: Safe to cache GET responses for 5-10 minutes
- **Case Sensitivity**: Account names are case-insensitive; addresses are case-sensitive

---

## Related Endpoints

- [AccountActions.md](AccountActions.md) — Retrieve and verify account credentials
- [AccountGroups.md](AccountGroups.md) — Group accounts for organization
- [Safes.md](Safes.md) — Manage safes containing accounts
- [Platforms.md](Platforms.md) — View/manage platform definitions
- [Users.md](Users.md) — Manage vault users with account access

---

## Example Usage

### List All Accounts (GET)
```bash
curl -X GET \
  "https://vault.example.com/api/Accounts?limit=50" \
  -H "Authorization: CyberArk <token>" \
  -H "Accept: application/json"
```

### Response
```json
[
  {
    "id": 123,
    "name": "prod-admin-01",
    "address": "prod-server.example.com",
    "username": "administrator",
    "platformId": "WinDomainAccount",
    "safeId": "ProdAccounts"
  },
  {
    "id": 124,
    "name": "prod-admin-02",
    "address": "prod-server-2.example.com",
    "username": "admin",
    "platformId": "WinDomainAccount",
    "safeId": "ProdAccounts"
  }
]
```

### Create Account (POST)
```bash
curl -X POST \
  https://vault.example.com/api/Accounts \
  -H "Authorization: CyberArk <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "prod-admin-03",
    "address": "prod-server-3.example.com",
    "username": "administrator",
    "platformId": "WinDomainAccount",
    "safeId": "ProdAccounts",
    "password": "InitialPass123!"
  }'
```

### Update Account (PUT)
```bash
curl -X PUT \
  https://vault.example.com/api/Accounts/125 \
  -H "Authorization: CyberArk <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "address": "new-prod-server.example.com",
    "tags": {
      "Environment": "Production"
    }
  }'
```

---

**Last Updated**: 2026-05-03
