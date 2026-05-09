# AccountSecretVersions

## Header

| Field | Value |
|-------|-------|
| **File** | AccountSecretVersions.md |
| **Version** | 14.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20accountsecretversions%20web%20services.htm |
| **Build** | 8.3.6 |
| **Status** | Complete |
| **New in v14.2** | Yes |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET |
| **Endpoint** | /api/Accounts/{id}/Secret/Versions |
| **Description** | Retrieve historical password versions for an account |
| **Auth Required** | Yes |

---

## Purpose

Access password version history for accounts. Support compliance audits, incident investigation, and secret rotation tracking. View all historical passwords with timestamps.

---

## Full Path

```
GET /api/Accounts/{AccountID}/Secret/Versions
GET /api/Accounts/{AccountID}/Secret/Versions?limit=50&offset=0
```

---

## HTTP Method

### GET - List Secret Versions
- **Purpose**: Retrieve account password version history
- **Body**: None
- **Response**: JSON array of secret versions

---

## Authentication

**Required**: Yes

```
Authorization: CyberArk <session_token>
```

---

## Parameters

### URL Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| {AccountID} | integer | Yes | Account ID |

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| limit | integer | No | Max results | Default: 25 |
| offset | integer | No | Pagination offset | Default: 0 |

---

## Response

```json
[
  {
    "VersionID": 1,
    "Password": "***[hidden]***",
    "PasswordHash": "sha256:...",
    "CreatedDate": "2026-04-15T10:30:00Z",
    "ExpiryDate": "2026-05-15T10:30:00Z",
    "Action": "Rotated",
    "CreatedBy": "VAULT\\Admin"
  },
  {
    "VersionID": 2,
    "Password": "***[hidden]***",
    "PasswordHash": "sha256:...",
    "CreatedDate": "2026-03-15T14:22:00Z",
    "ExpiryDate": "2026-04-15T10:30:00Z",
    "Action": "Automatic",
    "CreatedBy": "CyberArk"
  }
]
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Success |
| 400 | Bad Request | Invalid account ID |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No access to account |
| 404 | Not Found | Account not found |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Password Visibility**: Actual passwords are masked (***[hidden]***)
- **Hash Only**: Only password hashes returned for audit trails
- **Compliance**: Full version history retained per retention policy
- **Sorting**: Versions returned newest to oldest
- **Pagination**: Use limit/offset for large version histories

---

## Related Endpoints

- [Accounts.md](Accounts.md) — Account management
- [AccountActions.md](AccountActions.md) — Retrieve current password

---

## Example Usage

### Get Secret Version History
```bash
curl -X GET \
  "https://vault.example.com/api/Accounts/123/Secret/Versions?limit=10" \
  -H "Authorization: CyberArk <token>"
```

### Response
```json
[
  {
    "VersionID": 1,
    "CreatedDate": "2026-04-15T10:30:00Z",
    "ExpiryDate": "2026-05-15T10:30:00Z",
    "Action": "Rotated",
    "CreatedBy": "VAULT\\Admin"
  }
]
```

---

**Last Updated**: 2026-05-03
