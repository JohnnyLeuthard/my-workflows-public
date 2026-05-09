# Safes

## Header

| Field | Value |
|-------|-------|
| **File** | Safes.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20safes%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/Safes |
| **Description** | Create, retrieve, update, and delete safes (vaults) |
| **Auth Required** | Yes |

---

## Purpose

Manage safes (vaults) that store and organize accounts. Safes are containers with granular access controls. Create new safes, retrieve safe details, update safe properties, and delete safes.

---

## Full Path

### List All Safes
```
GET /api/Safes
```

### Get Single Safe
```
GET /api/Safes/{SafeID}
```

### Create Safe
```
POST /api/Safes
```

### Update Safe
```
PUT /api/Safes/{SafeID}
```

### Delete Safe
```
DELETE /api/Safes/{SafeID}
```

---

## HTTP Method

### GET /api/Safes
- **Purpose**: List all safes or retrieve single safe
- **Body**: None
- **Response**: JSON array (list) or object (single)

### POST /api/Safes
- **Purpose**: Create a new safe
- **Body**: JSON object with safe properties
- **Response**: JSON object with created safe details

### PUT /api/Safes/{SafeID}
- **Purpose**: Update safe properties
- **Body**: JSON object with fields to update
- **Response**: JSON object with updated safe

### DELETE /api/Safes/{SafeID}
- **Purpose**: Delete a safe (must be empty)
- **Body**: None
- **Response**: HTTP 204 No Content

---

## Authentication

**Required**: Yes — CyberArk session token

```
Authorization: CyberArk <session_token>
```

**Permissions**:
- GET: Read on safe
- POST: Create safes (vault admin)
- PUT: Manage safe (vault admin)
- DELETE: Manage safe (vault admin)

---

## Parameters

### URL Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| {SafeID} | string | Yes (single ops) | Safe unique identifier |

### Query Parameters (GET list)

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| search | string | No | Search by safe name | search=Prod |
| limit | integer | No | Max results | limit=50 |
| offset | integer | No | Pagination offset | offset=0 |

### Headers

| Header | Value | Required |
|--------|-------|----------|
| Authorization | CyberArk <token> | Yes |
| Content-Type | application/json | Yes (POST/PUT) |

---

## Request Body

### Create/Update Safe

```json
{
  "SafeName": "ProductionAccounts",
  "Description": "Production system accounts",
  "Location": "\\Prod\\",
  "OLACEnabled": true,
  "NumberOfVersionsRetention": 5
}
```

### Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| SafeName | string | Yes | Display name | Max 128 chars, unique |
| Description | string | No | Safe description | Max 256 chars |
| Location | string | No | Logical location path | Format: \\folder\\subfolder |
| OLACEnabled | boolean | No | Enable Object Level Access Control | Default: false |
| NumberOfVersionsRetention | integer | No | Account version history to keep | Default: 5 |

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Successful GET or PUT |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Safe not found |
| 409 | Conflict | Safe name already exists |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Safe Names**: Must be unique; case-insensitive
- **Deletion**: Safe must be empty (no accounts); delete accounts first
- **OLAC**: Object-level access control enables fine-grained permissions
- **Version Retention**: Older account versions automatically deleted per policy
- **Location**: Organizes safes hierarchically in vault

---

## Related Endpoints

- [Accounts.md](Accounts.md) — Manage accounts in safes
- [Users.md](Users.md) — Assign safe permissions to users

---

**Last Updated**: 2026-05-03
