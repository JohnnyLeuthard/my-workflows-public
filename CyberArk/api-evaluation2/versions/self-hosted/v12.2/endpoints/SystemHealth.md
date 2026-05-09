# SystemHealth

## Header

| Field | Value |
|-------|-------|
| **File** | SystemHealth.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20systemhealth%20web%20services.htm |
| **Build** | 8.2.5 |
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
