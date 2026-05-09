# SSHKeys

## Header

| Field | Value |
|-------|-------|
| **File** | SSHKeys.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20sshkeys%20web%20services.htm |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, DELETE |
| **Endpoint** | /api/SSHKeys |
| **Description** | Manage SSH public keys for accounts |
| **Auth Required** | Yes |

---

## Purpose

Store and manage SSH public keys for key-based authentication on accounts.

---

## Full Path

```
GET /api/SSHKeys
POST /api/SSHKeys
GET /api/SSHKeys/{KeyID}
DELETE /api/SSHKeys/{KeyID}
```

---

## Request Body (POST)

```json
{
  "AccountID": 123,
  "KeyType": "RSA",
  "PublicKey": "ssh-rsa AAAAB3NzaC1yc2E...",
  "KeyName": "prod-key-01"
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
| 404 | Not Found | Key or account not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
