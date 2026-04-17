# Error Codes & Handling Reference

> **Status: STUB** — Populate from vendor docs and observed behavior.

---

## Overview

CyberArk REST API errors use standard HTTP status codes combined with a JSON error body. Always check both the status code and the response body when handling errors.

---

## HTTP Status Codes

| Code | Meaning | Common Causes |
|---|---|---|
| `200` | OK | Successful GET/POST |
| `201` | Created | Successful resource creation |
| `204` | No Content | Successful DELETE |
| `400` | Bad Request | Malformed request body, missing required field |
| `401` | Unauthorized | Missing or expired session token |
| `403` | Forbidden | Insufficient permissions for the operation |
| `404` | Not Found | Resource (account, safe, user) does not exist |
| `409` | Conflict | Resource already exists (duplicate name) |
| `500` | Internal Server Error | Vault-side error — check PVWA and Vault logs |

> Populate additional codes as encountered.

---

## Error Response Body

> Populate exact JSON shape from vendor docs. Expected structure:

```json
{
  "ErrorCode": "ITATS...",
  "ErrorMessage": "Human-readable description"
}
```

---

## Common CyberArk Error Codes

> Populate from vendor docs and observed behavior.

| ErrorCode | Description | Resolution |
|---|---|---|
| `ITATS127E` | — | — |
| — | — | — |

---

## Error Handling Pattern (PowerShell)

> Populate recommended try/catch pattern for `Invoke-RestMethod`:

```powershell
try {
    $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -Body $Body -ErrorAction Stop
}
catch [System.Net.WebException] {
    # Read the error response body (Invoke-RestMethod swallows it by default)
    $statusCode = [int]$_.Exception.Response.StatusCode
    # ... populate full pattern
}
```

---

## Error Handling Pattern (Python)

> Populate recommended pattern for `requests`:

```python
response = session.post(url, json=body)
if not response.ok:
    error = response.json()
    # ... populate full pattern
```

---

## Retry Guidance

> Populate: which error codes warrant retry (e.g., 500 with transient vault load), which are permanent failures (401, 403, 404), recommended retry delay/backoff.

---

## Logging Guidance

- Log `ErrorCode` and `ErrorMessage` — these are safe to log
- **Never log** session tokens, passwords, or the request body if it contains a secret value
- Log the HTTP method, endpoint path, and status code for diagnostics
