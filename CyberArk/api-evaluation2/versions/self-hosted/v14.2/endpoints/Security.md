# Security

## Header

| Field | Value |
|-------|-------|
| **File** | Security.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20security%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, PUT |
| **Endpoint** | /api/Security |
| **Description** | Manage vault security configuration |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Configure SSL/TLS, encryption, and security policies.

---

## Full Path

```
GET /api/Security
GET /api/Security/SSLCertificates
PUT /api/Security/Encryption
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or PUT success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
