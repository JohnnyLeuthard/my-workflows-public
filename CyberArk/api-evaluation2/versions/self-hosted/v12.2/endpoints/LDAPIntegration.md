# LDAPIntegration

## Header

| Field | Value |
|-------|-------|
| **File** | LDAPIntegration.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20ldapintegration%20web%20services.htm |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT |
| **Endpoint** | /api/LDAPIntegration |
| **Description** | Configure LDAP/Active Directory integration |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Configure vault to authenticate users against LDAP/AD directories and sync groups.

---

## Full Path

```
GET /api/LDAPIntegration
POST /api/LDAPIntegration
PUT /api/LDAPIntegration/{ConfigID}
```

---

## Request Body (POST/PUT)

```json
{
  "DirectoryHostName": "dc.example.com",
  "Port": 389,
  "BaseDN": "CN=Users,DC=example,DC=com",
  "BindDN": "CN=ServiceAccount,CN=Users,DC=example,DC=com",
  "BindPassword": "Password123!"
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or PUT success |
| 201 | Created | POST success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
