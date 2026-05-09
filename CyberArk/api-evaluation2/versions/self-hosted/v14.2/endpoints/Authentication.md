# Authentication

## Header

| Field | Value |
|-------|-------|
| **File** | Authentication.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20authentication%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | POST, DELETE |
| **Endpoint** | /api/auth/logon, /api/auth/logoff |
| **Description** | Authenticate to the vault and obtain session tokens |
| **Auth Required** | No (for logon); Yes (for logoff) |

---

## Purpose

Obtain and terminate CyberArk vault API session tokens. The logon endpoint creates an authenticated session, returning a token valid for subsequent API requests. The logoff endpoint invalidates the token.

---

## Full Path

### Logon
```
POST /api/auth/logon
```

### Logoff
```
DELETE /api/auth/logoff
```

---

## HTTP Method

### POST /api/auth/logon
- **Purpose**: Authenticate and obtain a session token
- **Body**: JSON object with credentials
- **Response**: JSON object with session token

### DELETE /api/auth/logoff
- **Purpose**: Invalidate the current session token
- **Body**: None
- **Response**: HTTP 200 OK (empty body)

---

## Authentication

### Logon Endpoint
**No pre-authentication required** — This endpoint is used to obtain authentication.

Accepts credentials in one of these formats:
1. **Username/Password**:
   ```json
   {
     "username": "vault_user",
     "password": "user_password"
   }
   ```

2. **LDAP/Windows Integrated**:
   ```json
   {
     "username": "DOMAIN\\username",
     "password": "password",
     "concurrentSession": false
   }
   ```

3. **Certificate-Based**:
   - Include client certificate in request (handled by HTTPS client)
   - Body can be empty or include username

### Logoff Endpoint
**Requires valid session token**:
```
Authorization: CyberArk <session_token>
```

---

## Parameters

### URL Parameters
None

### Query Parameters
None

### Headers (Logon)

| Header | Value | Required | Description |
|--------|-------|----------|-------------|
| Content-Type | application/json | Yes | Request format |
| Accept | application/json | No | Response format |

### Headers (Logoff)

| Header | Value | Required | Description |
|--------|-------|----------|-------------|
| Authorization | CyberArk <token> | Yes | Session token to invalidate |

---

## Request Body

### Logon Request

```json
{
  "username": "api_user",
  "password": "SecurePassword123",
  "concurrentSession": false,
  "newPassword": "NewPassword123"
}
```

### Logon Field Descriptions

| Field | Type | Required | Description | Constraints |
|-------|------|----------|-------------|------------|
| username | string | Yes | Vault username or DOMAIN\\username for LDAP | Max 255 chars |
| password | string | Yes | User password | — |
| concurrentSession | boolean | No | Allow multiple concurrent sessions | Default: false |
| newPassword | string | No | New password if user is required to change on logon | — |

### Logoff Request
No request body required.

---

## Response Codes

| Code | Status | Description | Example Response |
|------|--------|-------------|------------------|
| 200 | OK (Logon) | Successfully authenticated | `{"CyberArkLogonResult":"<token_string>"}` |
| 200 | OK (Logoff) | Successfully logged off | (empty body) |
| 400 | Bad Request | Invalid JSON or missing required fields | `{"ErrorCode":"PASWS003E","ErrorMessage":"Missing parameters"}` |
| 401 | Unauthorized | Invalid username or password | `{"ErrorCode":"PASWS002E","ErrorMessage":"Invalid credentials"}` |
| 403 | Forbidden | User account locked or disabled | `{"ErrorCode":"PASWS008E","ErrorMessage":"User is not authorized"}` |
| 500 | Internal Server Error | Vault communication failure | `{"ErrorCode":"PASWS000E","ErrorMessage":"System error"}` |

---

## Notes

- **Token Format**: Returned token is a base64-encoded string; use directly in Authorization header
- **Token Expiration**: Default 30 minutes; adjust in vault configuration
- **Concurrent Sessions**: If concurrentSession=false (default), previous session of same user is invalidated
- **Failed Logon**: Failed logon attempts may lock user account after threshold
- **Logoff Safety**: Always logoff when done; unused tokens still consume resources
- **HTTPS Only**: Credentials sent over HTTP will be rejected

---

## Related Endpoints

- [Users.md](Users.md) — Manage vault users
- [General.md](General.md) — Check vault health and connectivity
- All other endpoints require valid authentication token from this endpoint

---

## Example Usage

### Logon Request (cURL)
```bash
curl -X POST \
  https://vault.example.com/api/auth/logon \
  -H "Content-Type: application/json" \
  -d '{
    "username": "api_user",
    "password": "SecurePassword123"
  }'
```

### Logon Response
```json
{
  "CyberArkLogonResult": "eyJzZXNzaW9uX2lkIjoiMTIzNDU2Nzg5MCJ9"
}
```

### Logoff Request
```bash
curl -X DELETE \
  https://vault.example.com/api/auth/logoff \
  -H "Authorization: CyberArk eyJzZXNzaW9uX2lkIjoiMTIzNDU2Nzg5MCJ9"
```

---

**Last Updated**: 2026-05-03
