# MonitorSessions

## Header

| Field | Value |
|-------|-------|
| **File** | MonitorSessions.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20monitorsessions%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET |
| **Endpoint** | /api/Sessions |
| **Description** | Monitor and retrieve active sessions |
| **Auth Required** | Yes |

---

## Purpose

Monitor active user sessions in the vault. Retrieve session details for auditing and compliance.

---

## Full Path

```
GET /api/Sessions
GET /api/Sessions/{SessionID}
```

---

## HTTP Method

### GET - List/Retrieve Sessions
- **Purpose**: List active sessions or get session details
- **Body**: None
- **Response**: JSON session(s)

---

## Authentication

**Required**: Yes

```
Authorization: CyberArk <session_token>
```

---

## Response

```json
[
  {
    "SessionID": "12345",
    "Username": "admin",
    "IPAddress": "192.168.1.100",
    "LoginTime": "2026-05-03T10:30:00Z",
    "LastActivity": "2026-05-03T10:45:00Z"
  }
]
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Success |
| 401 | Unauthorized | Invalid token |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Audit**: Use for session monitoring and compliance
- **Active Only**: Returns only active sessions

---

**Last Updated**: 2026-05-03
