# General

## Header

| Field | Value |
|-------|-------|
| **File** | General.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20general%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET |
| **Endpoint** | /api/General |
| **Description** | Retrieve general vault information |
| **Auth Required** | No |

---

## Purpose

Get basic vault information, server version, and API capabilities without authentication.

---

## Full Path

```
GET /api/General
GET /api/General/ApiVersion
```

---

## HTTP Method

### GET
- **Purpose**: Retrieve vault information
- **Body**: None
- **Response**: JSON with vault details

---

## Request Body

None

---

## Response

```json
{
  "ServerVersion | 14.2.8.2.5",
  "ApiVersion | 14.2",
  "WebServiceVersion | 14.2",
  "DomainName": "CYBERARK",
  "IdentityUserID": "admin"
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
