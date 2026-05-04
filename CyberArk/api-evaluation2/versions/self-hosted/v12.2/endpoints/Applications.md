# Applications

## Header

| Field | Value |
|-------|-------|
| **File** | Applications.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST |
| **Endpoint** | /api/Applications |
| **Description** | Manage API client applications |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Register and manage API client applications for certificate-based authentication.

---

## Full Path

```
GET /api/Applications
GET /api/Applications/{AppID}
POST /api/Applications
```

---

## Request Body (POST)

```json
{
  "AppName": "AutomationClient",
  "Description": "Automation and integration service"
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET success |
| 201 | Created | POST success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 404 | Not Found | Application not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
