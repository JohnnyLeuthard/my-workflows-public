# Authentication Methods Reference

> **Status: STUB** — Populate from vendor docs and environment config.
> Cross-reference: `../../_config/environment.md` for which auth method is in use per tier.

---

## Overview

CyberArk PVWA supports multiple authentication methods. The method in use determines:
- Which logon endpoint to call
- What request body parameters are required
- Whether MFA is involved (and how it's handled)
- Whether concurrent sessions are allowed

Always check `../../_config/environment.md` before writing auth code — do not assume the auth method.

---

## Methods

### CyberArk Native

**Logon endpoint:**
```
POST /PasswordVault/API/auth/Cyberark/Logon
```

> Populate: request body fields, response format, session token location, notes on password complexity requirements.

---

### LDAP / Active Directory

**Logon endpoint:**
```
POST /PasswordVault/API/auth/LDAP/Logon
```

> Populate: request body fields, domain handling, UPN vs. SAMAccountName, response format.

---

### RADIUS

**Logon endpoint:**
```
POST /PasswordVault/API/auth/RADIUS/Logon
```

> Populate: request body, OTP/passcode handling, challenge-response flow if applicable.

---

### Windows (IWA)

> Populate: endpoint, browser/Kerberos token handling, whether this is usable from PowerShell non-interactively.

---

### SAML

> Populate: endpoint, redirect flow, token exchange. Note: typically browser-only — may not be usable from CLI/PowerShell.

---

### PKI (Certificate)

> Populate: endpoint, certificate binding, client cert requirements.

---

## Session Token Handling

> Populate: exact header name for passing the token, token format (Bearer? Raw string?), lifetime, whether refresh is possible or re-logon is required.

---

## MFA Considerations

> Populate: which auth methods enforce MFA in this environment, how to handle OTP prompts non-interactively (service account patterns, RADIUS passcode in request body, etc.).

---

## CyberArkSession Class

The `CyberArkSession` PowerShell class (defined in `module/classes/`) stores:
- `BaseUrl` — PVWA base URL
- `Token` — session token (never logged or output)
- `AuthType` — which method was used
- `ExpiresAt` — token expiry if available

> Populate additional fields as vendor docs clarify the session token lifecycle.
