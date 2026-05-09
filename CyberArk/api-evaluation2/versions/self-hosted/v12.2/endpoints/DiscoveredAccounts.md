# DiscoveredAccounts

## Header

| Field | Value |
|-------|-------|
| **File** | DiscoveredAccounts.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20discoveredaccounts%20web%20services.htm |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, PUT |
| **Endpoint** | /api/DiscoveredAccounts |
| **Description** | Manage accounts discovered by privileged threat analysis |
| **Auth Required** | Yes |

---

## Purpose

Retrieve discovered accounts from security scanning and manage their onboarding.

---

## Full Path

```
GET /api/DiscoveredAccounts
PUT /api/DiscoveredAccounts/{AccountID}
```

---

## Request Body (PUT)

```json
{
  "Status": "onboarded",
  "TargetSafeID": "ProdAccounts",
  "TargetPlatformID": "UnixSSH"
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or PUT success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 404 | Not Found | Account not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
