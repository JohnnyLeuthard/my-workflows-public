# SessionManagement

## Header

| Field | Value |
|-------|-------|
| **File** | SessionManagement.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | POST, DELETE |
| **Endpoint** | /api/Sessions |
| **Description** | Control and terminate sessions |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Disconnect user sessions and manage session lifecycle.

---

## Full Path

```
DELETE /api/Sessions/{SessionID}
POST /api/Sessions/{SessionID}/Terminate
```

---

## HTTP Method

### DELETE - Terminate Session
- **Purpose**: Disconnect user session
- **Body**: None
- **Response**: HTTP 204

---

## Authentication

**Required**: Yes — Admin only

```
Authorization: CyberArk <admin_token>
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 204 | No Content | Session terminated |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 404 | Not Found | Session not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
