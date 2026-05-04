# AccountGroups

## Header

| Field | Value |
|-------|-------|
| **File** | AccountGroups.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/AccountGroups |
| **Description** | Group related accounts for organization |
| **Auth Required** | Yes |

---

## Purpose

Organize related accounts into groups for easier management and bulk operations.

---

## Full Path

```
GET /api/AccountGroups
POST /api/AccountGroups
PUT /api/AccountGroups/{GroupID}
DELETE /api/AccountGroups/{GroupID}
```

---

## Request Body

```json
{
  "Name": "ProductionDBAccounts",
  "Description": "All production database accounts"
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or PUT success |
| 201 | Created | POST success |
| 204 | No Content | DELETE success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 404 | Not Found | Group not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
