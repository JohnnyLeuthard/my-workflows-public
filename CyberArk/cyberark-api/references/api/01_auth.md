# Authentication API Reference

> **Status: PARTIAL**
> **Source:** https://docs.cyberark.com/pam-self-hosted/14.4/en/content/webservices/authenticate-using-rest-api.htm
> **Version:** 14.4 | **Last Updated:** 2026-04-16

---

## Overview

All PVWA REST API calls (except Logon) require an active session token obtained via a Logon endpoint. The token is passed as the `Authorization` header value. Sessions have a configurable idle timeout; on expiry the token is invalidated and a new Logon is required.

**Session model:** Token-based, not cookie-based. Store the token returned by Logon in `CyberArkSession.Token`.

---

## Endpoints

### CyberArk Native Logon
POST /PasswordVault/API/auth/Cyberark/Logon

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `username` | string | Yes | Vault username |
| `password` | string | Yes | Vault password |
| `concurrentSession` | bool | No | Allow concurrent sessions (default: false) |

**Response**

Returns a plain string (not JSON object) — the session token.

```
"<session_token_string>"
```

**Notes**
- Token is the raw response body, stripped of quotes
- Store in `CyberArkSession.Token`; pass as `Authorization: <token>` on all subsequent calls
- Password must meet vault complexity requirements
- If `concurrentSession: false` and user already has an active session, the old session is invalidated

---

### LDAP Logon
POST /PasswordVault/API/auth/LDAP/Logon

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `username` | string | Yes | LDAP username (UPN or SAMAccountName) |
| `password` | string | Yes | LDAP password |
| `concurrentSession` | bool | No | Allow concurrent sessions |

**Response:** Same as CyberArk Logon — plain session token string.

**Notes**
- Use UPN format (`user@domain.com`) or SAMAccountName depending on PVWA LDAP config
- If LDAP is not configured on PVWA, returns 401 Unauthorized
- Requires PVWA to be bound to an Active Directory/LDAP directory

---

### RADIUS Logon
POST /PasswordVault/API/auth/RADIUS/Logon

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `username` | string | Yes | Vault username |
| `password` | string | Yes | RADIUS OTP or passcode |
| `concurrentSession` | bool | No | Allow concurrent sessions |

**Response:** Plain session token string.

**Notes**
- Password field carries the OTP/passcode for non-interactive (service account) use
- Challenge-response (interactive MFA) is not usable non-interactively from PowerShell
- Requires RADIUS server configured on PVWA

---

### Windows/Kerberos (IWA) Logon
POST /PasswordVault/API/auth/Windows/Logon

**Minimum PVWA version:** 10.4+

**Request Body:** None (Windows Integrated Authentication handles credentials)

**Response:** Plain session token string.

**Notes**
- Only usable from Windows machines with Kerberos configured
- Not usable from non-interactive scripts or cross-platform environments
- Automatically uses the current user's Windows credentials
- May require double-hop configuration if PVWA and Vault are on different machines

---

### Logoff
POST /PasswordVault/API/auth/Logoff

**Minimum PVWA version:** 9.10+

**Request Body:** None

**Response:** `200 OK` with empty body

**Notes**
- Invalidates the session token immediately
- Always call in a `finally` block to prevent session leaks
- Returns 200 even if token was already expired
- Good practice: log off in error handlers to prevent token accumulation

---

## Session Token Usage

| Header | Value | Required | Notes |
|---|---|---|---|
| `Authorization` | Raw token string | Yes (all endpoints except Logon) | No `Bearer` prefix — just the token value |
| `Content-Type` | `application/json` | POST/PUT/PATCH | Required when sending request bodies |

**Token lifetime:** Governed by PVWA `SessionTimeout` setting (default: 20 minutes idle). No refresh endpoint — re-Logon is required on expiry.

**Concurrent sessions:** By default, logging on again invalidates the previous session. Set `concurrentSession: true` to allow multiple active tokens for the same user.

---

## Common Error Responses

| Status | ErrorCode | Cause | Resolution |
|---|---|---|---|
| 401 | — | Invalid username/password | Verify credentials and vault user exists |
| 401 | — | Session token expired | Re-logon with credentials |
| 403 | — | User account disabled | Contact vault admin |
| 500 | — | PVWA or Vault connection error | Check PVWA/Vault health and network connectivity |

---

## Version Notes

| Feature | Minimum Version | Notes |
|---|---|---|
| CyberArk / LDAP / RADIUS Logon | 9.10 | Baseline REST auth |
| Windows (IWA) Logon | 10.4 | Requires Kerberos configuration |
| SAML Logon | 11.4+ | Browser flow only; not usable from PowerShell non-interactively |
| PKI (Certificate) Logon | 11.4+ | Requires client certificate; not tested in most service account patterns |
| Concurrent sessions parameter | 10.9+ | `concurrentSession: true` parameter |
