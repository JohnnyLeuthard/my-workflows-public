# SystemHealth

## Header

| Field | Value |
|-------|-------|
| **File** | SystemHealth.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET |
| **Endpoint** | /api/SystemHealth |
| **Description** | Check vault health and operational status |
| **Auth Required** | No |

---

## Purpose

Monitor vault health, check API availability, and validate connectivity.

---

## Full Path

```
GET /api/SystemHealth
GET /api/SystemHealth/ComponentsStatus
```

---

## Response

```json
{
  "Status": "OK",
  "Components": {
    "EnterpriseVault": "OK",
    "IdentityManagement": "OK",
    "PasswordVault": "OK",
    "SessionRecording": "OK"
  }
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Vault operational |
| 503 | Service Unavailable | Vault maintenance or down |

---

**Last Updated**: 2026-05-03
