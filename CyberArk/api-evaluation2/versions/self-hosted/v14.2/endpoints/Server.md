# Server

## Header

| Field | Value |
|-------|-------|
| **File** | Server.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20server%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET |
| **Endpoint** | /api/Server |
| **Description** | Retrieve server information and configuration |
| **Auth Required** | No |

---

## Purpose

Get vault server version, build, and configuration details.

---

## Full Path

```
GET /api/Server
GET /api/Server/Status
```

---

## Response

```json
{
  "ServerVersion | 14.2.8.2.5",
  "Build | 8.3.6",
  "ServerName": "PrimaryVault",
  "DatabaseVersion": "12.0",
  "ComponentVersions": {}
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Success |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
