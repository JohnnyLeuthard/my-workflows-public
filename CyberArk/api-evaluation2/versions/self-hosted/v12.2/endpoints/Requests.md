# Requests

## Header

| Field | Value |
|-------|-------|
| **File** | Requests.md |
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
| **Endpoint** | /api/Requests |
| **Description** | Request and manage account access approvals |
| **Auth Required** | Yes |

---

## Purpose

Request temporary access to accounts with optional approval workflow. Retrieve pending/completed requests.

---

## Full Path

```
GET /api/Requests
POST /api/Requests
GET /api/Requests/{RequestID}
```

---

## HTTP Method

### GET - List/Retrieve Requests
- **Purpose**: List access requests or get request details
- **Body**: None
- **Response**: JSON request(s)

### POST - Create Request
- **Purpose**: Request access to account
- **Body**: JSON with request details
- **Response**: JSON created request

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
  "AccountID": 123,
  "Reason": "Production incident investigation",
  "DurationMinutes": 30,
  "MultipleAccessRequiredApprovers": true
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or POST success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No access |
| 404 | Not Found | Request or account not found |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Approval Required**: Some accounts require manager approval
- **Duration**: Specify access duration in minutes
- **Reason**: Logged for audit trail

---

## Related Endpoints

- [Accounts.md](Accounts.md) — Reference accounts in requests

---

**Last Updated**: 2026-05-03
