# OPMCommands

## Header

| Field | Value |
|-------|-------|
| **File** | OPMCommands.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20opmcommands%20web%20services.htm |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | POST |
| **Endpoint** | /api/OPMCommands |
| **Description** | Execute one-time password and command operations |
| **Auth Required** | Yes |

---

## Purpose

Execute one-time commands on managed systems using stored account credentials.

---

## Full Path

```
POST /api/OPMCommands
```

---

## Request Body

```json
{
  "AccountID": 123,
  "Command": "whoami",
  "Reason": "System verification"
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Command executed |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 404 | Not Found | Account not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
