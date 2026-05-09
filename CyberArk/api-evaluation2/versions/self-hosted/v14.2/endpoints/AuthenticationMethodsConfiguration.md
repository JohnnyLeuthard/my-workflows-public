# AuthenticationMethodsConfiguration

## Header

| Field | Value |
|-------|-------|
| **File** | AuthenticationMethodsConfiguration.md |
| **Version** | 14.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20authenticationmethodsconfiguration%20web%20services.htm |
| **Build** | 8.3.6 |
| **Status** | Complete |
| **New in v14.2** | Yes |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/Configuration/AuthenticationMethods |
| **Description** | Manage vault authentication method configuration centrally |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Configure and manage authentication methods for the vault. Enable/disable MFA, certificate requirements, authentication policies, and method-specific settings. Centralized authentication configuration for all vault users.

---

## Full Path

### List All Authentication Methods
```
GET /api/Configuration/AuthenticationMethods
```

### Get Single Authentication Method
```
GET /api/Configuration/AuthenticationMethods/{MethodID}
```

### Create Authentication Method
```
POST /api/Configuration/AuthenticationMethods
```

### Update Authentication Method
```
PUT /api/Configuration/AuthenticationMethods/{MethodID}
```

### Delete Authentication Method
```
DELETE /api/Configuration/AuthenticationMethods/{MethodID}
```

---

## HTTP Method

### GET - List/Retrieve
- **Purpose**: List all auth methods or retrieve single method details
- **Body**: None
- **Response**: JSON auth method(s)

### POST - Create
- **Purpose**: Create new authentication method configuration
- **Body**: JSON method configuration
- **Response**: JSON created method with ID

### PUT - Update
- **Purpose**: Update method settings
- **Body**: JSON with updates
- **Response**: JSON updated method

### DELETE - Delete
- **Purpose**: Remove authentication method
- **Body**: None
- **Response**: HTTP 204

---

## Authentication

**Required**: Yes — Vault Admin only

```
Authorization: CyberArk <admin_token>
```

---

## Request Body

### Create/Update

```json
{
  "MethodName": "MFA_LDAP",
  "MethodType": "LDAP",
  "Enabled": true,
  "MFARequired": true,
  "MFAType": "TOTP",
  "Properties": {
    "LDAPDirectory": "dc.example.com",
    "TOTPLength": 6,
    "TOTPTimeStep": 30
  }
}
```

### Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| MethodName | string | Yes | Method identifier | Unique name |
| MethodType | string | Yes | LDAP, SAML, Radius, Certificate | — |
| Enabled | boolean | No | Enable/disable method | Default: true |
| MFARequired | boolean | No | Enforce MFA for method | Default: false |
| MFAType | string | No | TOTP, SMS, Push | — |
| Properties | object | No | Method-specific settings | — |

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or PUT success |
| 201 | Created | POST success |
| 204 | No Content | DELETE success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 404 | Not Found | Method not found |
| 409 | Conflict | Method name exists |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Built-in Methods**: Some default methods cannot be deleted
- **MFA Integration**: MFA can be enforced per method or globally
- **LDAP/SAML**: External authentication requires proper directory configuration
- **Method Priority**: Vault can support multiple auth methods simultaneously
- **Fallback**: Vault admin always has local authentication fallback

---

## Related Endpoints

- [Authentication.md](Authentication.md) — User logon/logoff using configured methods
- [Users.md](Users.md) — Assign methods to users

---

## Example Usage

### Create LDAP with MFA
```bash
curl -X POST \
  https://vault.example.com/api/Configuration/AuthenticationMethods \
  -H "Authorization: CyberArk <admin_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "MethodName": "LDAP_MFA",
    "MethodType": "LDAP",
    "Enabled": true,
    "MFARequired": true,
    "MFAType": "TOTP",
    "Properties": {
      "LDAPDirectory": "dc.prod.com"
    }
  }'
```

---

**Last Updated**: 2026-05-03
