# PTAInstallation

## Header

| Field | Value |
|-------|-------|
| **File** | PTAInstallation.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20ptainstallation%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST |
| **Endpoint** | /api/PTA |
| **Description** | Manage PTA (Privileged Threat Analytics) scanner installation |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Configure and manage Privileged Threat Analytics scanners for account discovery.

---

## Full Path

```
GET /api/PTA/Installation
POST /api/PTA/Installation
```

---

## Request Body

```json
{
  "ScannerName": "Scanner-01",
  "ScannerIP": "192.168.1.50",
  "Targets": ["192.168.1.0/24"]
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or POST success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
