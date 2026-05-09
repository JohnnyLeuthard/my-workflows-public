# Users

## Header

| Field | Value |
|-------|-------|
| **File** | Users.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20users%20web%20services.htm |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/Users |
| **Description** | Manage vault users and API consumer accounts |
| **Auth Required** | Yes (Vault Admin) |

---

## Purpose

Create and manage vault users. Users access the vault through desktop clients, web UI, or API. Create service accounts for automation, API consumers, LDAP directory users.

---

## Full Path

```
GET /api/Users
GET /api/Users/{UserID}
POST /api/Users
PUT /api/Users/{UserID}
DELETE /api/Users/{UserID}
```

---

## HTTP Method

### GET - List/Retrieve Users
- **Purpose**: List all users or get single user
- **Body**: None
- **Response**: JSON user(s)

### POST - Create User
- **Purpose**: Create new vault user
- **Body**: JSON with user properties
- **Response**: JSON with created user

### PUT - Update User
- **Purpose**: Update user properties
- **Body**: JSON with fields to update
- **Response**: JSON updated user

### DELETE - Delete User
- **Purpose**: Remove user from vault
- **Body**: None
- **Response**: HTTP 204

---

## Authentication

**Required**: Yes — Vault Admin token only

```
Authorization: CyberArk <admin_token>
```

---

## Request Body

```json
{
  "UserName": "api_automation",
  "InitialPassword": "SecurePassword123!",
  "Email": "automation@company.com",
  "FirstName": "API",
  "LastName": "Automation",
  "ExpiryDate": "31/12/2026",
  "UserType": "EPVUser",
  "Location": "\\",
  "IsExpired": false
}
```

### Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| UserName | string | Yes | Unique username | Max 255 chars |
| InitialPassword | string | Yes (POST) | Initial password | — |
| Email | string | No | Email address | — |
| FirstName | string | No | User first name | — |
| LastName | string | No | User last name | — |
| ExpiryDate | string | No | Account expiry (DD/MM/YYYY) | — |
| UserType | string | No | EPVUser, CyberArkUser, LDAPUser | Default: EPVUser |
| Location | string | No | Location path | — |
| IsExpired | boolean | No | Account active/inactive | Default: false |

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or PUT success |
| 201 | Created | POST success |
| 204 | No Content | DELETE success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 404 | Not Found | User not found |
| 409 | Conflict | Username exists |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Admin Only**: User creation requires vault administrator token
- **LDAP Users**: Automatically created on first login if enabled
- **Account Expiry**: Expired accounts locked; cannot log in
- **Password Policy**: Must comply with vault password policy
- **User Types**: EPVUser (vault), CyberArkUser (SaaS), LDAPUser (directory)

---

## Related Endpoints

- [Authentication.md](Authentication.md) — User login and logoff
- [Safes.md](Safes.md) — Assign safe permissions to users

---

**Last Updated**: 2026-05-03
