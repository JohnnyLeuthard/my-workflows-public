# AccountActions

## Header

| Field | Value |
|-------|-------|
| **File** | AccountActions.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/sdk/api%20commands%20-%20accountactions%20web%20services.htm |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST |
| **Endpoint** | /api/AccountActions |
| **Description** | Retrieve and verify account credentials |
| **Auth Required** | Yes |

---

## Purpose

Retrieve account passwords (secrets) and verify account credentials on target systems. Logs credential access for audit and compliance tracking.

---

## Full Path

```
GET /api/AccountActions?accountID={id}&action=retrieve
GET /api/AccountActions?accountID={id}&action=verify
POST /api/AccountActions
```

---

## HTTP Method

### GET - Retrieve/Verify Credentials
- **Purpose**: Retrieve account password or verify on target
- **Body**: None
- **Response**: JSON with password or verification result

### POST - Retrieve with Reason
- **Purpose**: Retrieve password with audit reason
- **Body**: JSON with request details
- **Response**: JSON with password

---

## Authentication

**Required**: Yes

```
Authorization: CyberArk <session_token>
```

---

## Request Body (POST)

```json
{
  "accountID": 123,
  "action": "retrieve",
  "reason": "Production maintenance",
  "isConnectAssumed": false
}
```

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| accountID | integer | Yes | Target account ID |
| action | string | Yes | "retrieve" or "verify" |
| reason | string | No | Audit reason for retrieval |
| isConnectAssumed | boolean | No | Assume session already connected |

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Credential retrieved/verified |
| 400 | Bad Request | Invalid account or action |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No access to account |
| 404 | Not Found | Account not found |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Audit Logging**: All credential retrievals logged with user, timestamp, reason
- **Verification**: Verify action tests credential on actual target system
- **Scope**: Requires ReadAccounts permission on safe

---

## Related Endpoints

- [Accounts.md](Accounts.md) — Account management

---

**Last Updated**: 2026-05-03
