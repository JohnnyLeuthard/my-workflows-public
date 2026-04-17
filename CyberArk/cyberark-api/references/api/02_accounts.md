# Accounts API Reference

> **Status: PARTIAL**
> **Source:** https://docs.cyberark.com/pam-self-hosted/14.4/en/content/webservices/account-management.htm
> **Version:** 14.4 | **Last Updated:** 2026-04-16

---

## Overview

An **account** in CyberArk is a credential object stored in a safe. Each account belongs to exactly one safe and follows a platform policy. Accounts support credentials for systems, applications, cloud services, and databases. The Accounts API provides full CRUD access plus password operations (verify, change, reconcile).

---

## Endpoints

### List Accounts
GET /PasswordVault/API/Accounts

**Minimum PVWA version:** 9.10+

**Query Parameters**
| Parameter | Type | Required | Description |
|---|---|---|---|
| `search` | string | No | Search by account name (substring match) |
| `safeName` | string | No | Filter by safe name |
| `offset` | int | No | Pagination offset (default: 0) |
| `limit` | int | No | Results per page (default: 25, max: 1000) |
| `sort` | string | No | Sort field (e.g., `name`, `platformId`) |

**Response**

Returns a list of account objects.

```json
{
  "accounts": [
    {
      "id": "1_1",
      "name": "oracle-prod-dbadmin",
      "address": "prod-db.example.com",
      "userName": "dbadmin",
      "platformId": "Oracle",
      "safeName": "App-Oracle-PROD",
      "secretType": "password",
      "createdTime": 1609459200
    }
  ],
  "count": 1
}
```

**Notes**
- Use `offset` + `limit` for pagination
- `search` is case-insensitive substring match

---

### Get Account
GET /PasswordVault/API/Accounts/{accountId}

**Minimum PVWA version:** 9.10+

**Path Parameters**
| Parameter | Type | Description |
|---|---|---|
| `accountId` | string | Internal account ID (from List Accounts) |

**Response**

```json
{
  "id": "1_1",
  "name": "oracle-prod-dbadmin",
  "address": "prod-db.example.com",
  "userName": "dbadmin",
  "platformId": "Oracle",
  "safeName": "App-Oracle-PROD",
  "secretType": "password",
  "createdTime": 1609459200,
  "modificationTime": 1609459200,
  "createdBy": "admin",
  "accessibleByUsers": ["admin", "dba-team"],
  "platformAccountProperties": {
    "SQLSERVER": "prod-db.example.com",
    "LogonDomain": "EXAMPLE"
  }
}
```

**Notes**
- `platformAccountProperties` varies by platform type
- This endpoint does NOT include the password value

---

### Add Account
POST /PasswordVault/API/Accounts

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | Account object name (must be unique within safe) |
| `address` | string | Yes | Target system hostname/IP/address |
| `userName` | string | Yes | Account username on the target system |
| `safeName` | string | Yes | Containing safe name |
| `platformId` | string | Yes | Platform policy ID (e.g., `Oracle`, `Windows`, `MySQL`) |
| `secretType` | string | No | `password` (default) or `key` |
| `secret` | string | Yes (if secretType=password) | The actual password for the account |
| `platformAccountProperties` | object | No | Platform-specific properties (varies by platformId) |
| `automaticChangeEnabled` | bool | No | Enable CPM automatic password change |
| `manualChangeEnabled` | bool | No | Allow manual password change |

**Example**

```json
{
  "name": "oracle-prod-dbadmin",
  "address": "prod-db.example.com",
  "userName": "dbadmin",
  "safeName": "App-Oracle-PROD",
  "platformId": "Oracle",
  "secret": "MySecurePassword123!",
  "automaticChangeEnabled": true,
  "platformAccountProperties": {
    "SQLSERVER": "prod-db.example.com"
  }
}
```

**Response**

Returns the new account object with assigned `id`.

**Notes**
- `platformAccountProperties` depends on the platform policy configuration
- `secret` is the actual credential value (encrypted in transit with HTTPS)
- Safe membership determines who can access this account

---

### Update Account
PATCH /PasswordVault/API/Accounts/{accountId}

**Minimum PVWA version:** 9.10+

**Request Body** (JSON Patch format)

Supports partial updates using RFC 6902 JSON Patch.

```json
[
  { "op": "replace", "path": "/address", "value": "new-host.example.com" },
  { "op": "replace", "path": "/secret", "value": "NewPassword456!" },
  { "op": "replace", "path": "/platformAccountProperties/LogonDomain", "value": "NEWDOMAIN" }
]
```

**Notes**
- Use `replace` operation to modify any field
- Cannot change `safeName` or `platformId` after creation

---

### Delete Account
DELETE /PasswordVault/API/Accounts/{accountId}

**Minimum PVWA version:** 9.10+

**Response:** `204 No Content`

**Notes**
- This operation is permanent and cannot be reversed
- Only safe members with Delete permission can perform this

---

### Verify Account (Check Password)
POST /PasswordVault/API/Accounts/{accountId}/Verify

**Minimum PVWA version:** 9.10+

**Request Body:** None

**Response:** `200 OK` with empty body if password is correct

**Notes**
- Triggers an immediate logon attempt to the target system
- Returns `200` if credentials are valid, `400` if invalid
- Requires CPM to have connectivity to the target system
- Does not change the password

---

### Change Password
POST /PasswordVault/API/Accounts/{accountId}/Change

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `newPassword` | string | Yes | The new password to set |
| `changeEntireGroup` | bool | No | If true, change password on all linked accounts (default: false) |

**Response:** `204 No Content`

**Notes**
- Requires CPM to have Change permissions on the target system
- The account password is immediately changed on both the target and in the vault
- Returns immediately; actual change is async CPM operation

---

### Reconcile Password
POST /PasswordVault/API/Accounts/{accountId}/Reconcile

**Minimum PVWA version:** 11.4+

**Request Body:** None

**Response:** `204 No Content`

**Notes**
- Resets the vault password to match the current password on the target system
- Used when the target password was changed outside of CyberArk
- Returns immediately; actual reconciliation is async CPM operation

---

### Get Password Value
POST /PasswordVault/API/Accounts/{accountId}/Password/Retrieve

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `reason` | string | No | Reason for password retrieval (audit trail) |
| `ticketId` | string | No | External ticket ID (audit trail) |

**Response**

```
"MySecurePassword123!"
```

**Notes**
- Returns the password as a plain string (not JSON)
- Requires safe membership with Retrieve Secret permission
- Access is logged and audited
- CRITICAL: Never log or display this value; use it immediately and discard

---

## Account Object Reference

**Common fields in account objects:**

| Field | Type | Description |
|---|---|---|
| `id` | string | Internal CyberArk account ID |
| `name` | string | Account display name (unique within safe) |
| `address` | string | Target system address/hostname |
| `userName` | string | Username on target system |
| `safeName` | string | Containing safe |
| `platformId` | string | Platform policy ID |
| `secretType` | string | `password` or `key` |
| `createdTime` | int | Unix timestamp (seconds since epoch) |
| `modificationTime` | int | Unix timestamp of last update |
| `createdBy` | string | Username of creator |
| `accessibleByUsers` | array | List of vault users with access |
| `platformAccountProperties` | object | Platform-specific metadata |
| `automaticChangeEnabled` | bool | CPM auto-change enabled |
| `manualChangeEnabled` | bool | Manual password change allowed |
| `secretManagementEnabled` | bool | Secret is managed |

---

## Common Error Responses

| Status | Cause | Resolution |
|---|---|---|
| 400 | Account name already exists in safe | Use unique name within safe |
| 400 | Invalid platformId | Verify platform exists in vault |
| 400 | Invalid secretType | Use `password` or `key` |
| 403 | Insufficient safe member permissions | Request safe membership upgrade |
| 404 | Account does not exist | Verify accountId is correct |
| 409 | Account name conflict | Another account already has this name |

---

## Version Notes

| Feature | Minimum Version | Notes |
|---|---|---|
| Basic CRUD (add, get, update, delete) | 9.10 | Baseline account operations |
| Verify account | 9.10 | Check password validity |
| Change password | 9.10 | CPM-driven password change |
| Reconcile password | 11.4 | Sync vault password with target |
| JSON Patch (PATCH endpoint) | 10.x | Partial updates |
