# LinkedAccounts

## Header

| Field | Value |
|-------|-------|
| **File** | LinkedAccounts.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20linkedaccounts%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, DELETE |
| **Endpoint** | /api/LinkedAccounts |
| **Description** | Link related accounts across systems |
| **Auth Required** | Yes |

---

## Purpose

Link dependent accounts (e.g., admin account linked to service account) for coordinated password management.

---

## Full Path

```
GET /api/LinkedAccounts
POST /api/LinkedAccounts
DELETE /api/LinkedAccounts/{LinkID}
```

---

## Request Body (POST)

```json
{
  "PrimaryAccountID": 123,
  "SecondaryAccountID": 124,
  "Description": "Dependency relationship"
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET success |
| 201 | Created | POST success |
| 204 | No Content | DELETE success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 404 | Not Found | Account not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
