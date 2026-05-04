# BulkUpload

## Header

| Field | Value |
|-------|-------|
| **File** | BulkUpload.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | POST |
| **Endpoint** | /api/BulkUpload |
| **Description** | Bulk import accounts from CSV |
| **Auth Required** | Yes |

---

## Purpose

Import large account batches from CSV files for efficiency.

---

## Full Path

```
POST /api/BulkUpload
```

---

## Request Body

Multipart form with CSV file:
```
--boundary
Content-Disposition: form-data; name="file"; filename="accounts.csv"
Content-Type: text/csv

Name,Address,Username,Platform,Safe
prod-admin,server.com,admin,Windows,Prod
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Upload successful |
| 400 | Bad Request | Invalid CSV format |
| 401 | Unauthorized | Invalid token |
| 413 | Payload Too Large | File too large |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
