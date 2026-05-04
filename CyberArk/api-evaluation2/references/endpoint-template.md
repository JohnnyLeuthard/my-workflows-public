# [Endpoint Name]

## Header

| Field | Value |
|-------|-------|
| **File** | [Filename].md |
| **Version** | [12.2 / 14.2 / 14.4] |
| **Platform** | Self-Hosted / Privilege Cloud |
| **Source** | [CyberArk docs URL] |
| **Build** | [Build number] |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE (as applicable) |
| **Endpoint** | /api/[Resource] |
| **Description** | [One-line description of what this endpoint does] |
| **Auth Required** | Yes / No / CertificateAuth / Windows |

---

## Purpose

[Describe the business purpose of this endpoint. What problem does it solve? What does it enable?]

Example:
- Retrieve account credentials for authentication
- Create a new account in the vault
- Update account metadata
- Delete a managed account

---

## Full Path

### Example Paths

```
GET /api/Accounts
GET /api/Accounts/123
POST /api/Accounts
PUT /api/Accounts/123
DELETE /api/Accounts/123
```

### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes (for single-account ops) | Numeric account ID in vault |

---

## HTTP Method

### GET
- **Purpose**: Retrieve account data
- **Body**: None
- **Response**: JSON object or array

### POST
- **Purpose**: Create a new account
- **Body**: JSON object with account details
- **Response**: JSON object with newly created account (including assigned ID)

### PUT
- **Purpose**: Update an existing account
- **Body**: JSON object with updated fields
- **Response**: JSON object with updated account

### DELETE
- **Purpose**: Delete an account
- **Body**: None
- **Response**: HTTP 204 No Content or JSON success message

---

## Authentication

### Required
- **Type**: [Certificate / Windows / API Key / OAuth / Token]
- **Header**: Authorization: [Format]
- **Examples**:
  ```
  Authorization: Bearer <token>
  Authorization: CyberArk <session-token>
  X-CERT-THUMBPRINT: <cert-thumbprint>
  ```

### Optional
- [List any optional auth overrides or alternative methods]

---

## Parameters

### URL Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| {id} | integer | Yes (some methods) | Account ID |

### Query Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| search | string | No | Filter by name or property | ?search=admin |
| limit | integer | No | Max results per page | ?limit=100 |
| offset | integer | No | Pagination offset | ?offset=0 |

### Headers

| Header | Value | Required | Description |
|--------|-------|----------|-------------|
| Content-Type | application/json | Yes (POST/PUT) | Request format |
| Accept | application/json | No | Response format |
| Authorization | See Auth section | Yes | Authentication credential |

---

## Request Body

### JSON Schema

```json
{
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "description": "Account name (display name)"
    },
    "address": {
      "type": "string",
      "description": "Target system hostname or IP"
    },
    "username": {
      "type": "string",
      "description": "Account username on target system"
    },
    "platformId": {
      "type": "string",
      "description": "Platform ID (e.g., 'Unix', 'Windows')"
    },
    "safeId": {
      "type": "string",
      "description": "Numeric safe ID where account is stored"
    }
  },
  "required": ["name", "address", "username", "platformId", "safeId"]
}
```

### Field Descriptions

| Field | Type | Required | Description | Constraints |
|-------|------|----------|-------------|------------|
| name | string | Yes | Display name for account | Max 128 chars, unique per safe |
| address | string | Yes | Target system hostname or IP | Hostname or valid IP |
| username | string | Yes | Account username on target | Platform-dependent format |
| platformId | string | Yes | Platform identifier | Must exist in vault |
| safeId | string | Yes | Safe containing account | Must have owner permission |
| password | string | Conditional | Initial secret (POST only) | Not returned in GET |
| secretManagement | object | No | Secret rotation config | See SecretManagement schema |

### Conditional Fields

- **password**: Required in POST requests; ignored in PUT (use secret version endpoint)
- **secretManagement**: Only valid for accounts with rotation enabled

---

## Response Codes

| Code | Status | Description | Example Response |
|------|--------|-------------|------------------|
| 200 | OK | Successful GET or PUT | `{ "id": 123, "name": "admin-prod", ... }` |
| 201 | Created | Successful POST | `{ "id": 456, "name": "new-account", ... }` |
| 204 | No Content | Successful DELETE | (empty body) |
| 400 | Bad Request | Invalid parameters | `{ "error": "Invalid platformId" }` |
| 401 | Unauthorized | Missing or invalid auth | `{ "error": "Unauthorized" }` |
| 403 | Forbidden | Insufficient permissions | `{ "error": "Access denied" }` |
| 404 | Not Found | Resource not found | `{ "error": "Account not found" }` |
| 409 | Conflict | Resource already exists | `{ "error": "Account name already exists" }` |
| 500 | Internal Server Error | Server-side error | `{ "error": "Internal server error" }` |

---

## Notes

- **Pagination**: List endpoints support `limit` and `offset` for large result sets
- **Rate Limiting**: No documented limits; assume standard REST best practices
- **Caching**: Safe to cache GET responses for short periods (5-10 min)
- **Secrets**: Account passwords are never returned in GET responses except via dedicated secret endpoints
- **Audit**: All changes are logged in vault audit trail

---

## Related Endpoints

- [Accounts/Secret/Versions](/v12.2/endpoints/Accounts.md#secret-versions) — Retrieve historical secret versions
- [SafeMembers](/v12.2/endpoints/Safes.md#members) — Manage safe permissions
- [Platforms](/v12.2/endpoints/Platforms.md) — View available platforms
- [Users](/v12.2/endpoints/Users.md) — Manage vault users

---

**Template Version**: 1.0  
**Last Updated**: [Date]
