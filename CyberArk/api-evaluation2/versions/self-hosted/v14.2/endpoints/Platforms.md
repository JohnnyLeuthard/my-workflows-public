# Platforms

## Header

| Field | Value |
|-------|-------|
| **File** | Platforms.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20platforms%20web%20services.htm |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/Platforms |
| **Description** | Manage platform definitions for target systems |
| **Auth Required** | Yes (Vault Admin) |

---

## Purpose

Define and manage platforms for account management. Platforms specify how accounts are managed on different system types (Windows, Unix, AWS, etc.) including password rotation, connection methods, and constraints.

---

## Full Path

```
GET /api/Platforms
GET /api/Platforms/{PlatformID}
POST /api/Platforms
PUT /api/Platforms/{PlatformID}
DELETE /api/Platforms/{PlatformID}
```

---

## HTTP Method

### GET - List/Retrieve Platforms
- **Purpose**: List platforms or retrieve platform details
- **Body**: None
- **Response**: JSON platform(s)

### POST - Create Platform
- **Purpose**: Create new platform definition
- **Body**: JSON platform configuration
- **Response**: JSON created platform

### PUT - Update Platform
- **Purpose**: Update platform settings
- **Body**: JSON with updates
- **Response**: JSON updated platform

### DELETE - Delete Platform
- **Purpose**: Remove platform (cannot be in use)
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

```json
{
  "Name": "WinDomainAccount",
  "Description": "Windows Domain Account",
  "BasePlatformID": "WinDomainAccountBase",
  "AllowedSafes": [],
  "RotationIntervalDays": 30,
  "RotationMode": "Immediate",
  "PropertiesMapping": {
    "Username": "UserName",
    "Address": "ComputerName"
  }
}
```

### Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| Name | string | Yes | Platform name | Unique identifier |
| Description | string | No | Platform description | — |
| BasePlatformID | string | No | Base platform to inherit from | — |
| AllowedSafes | array | No | Restrict to specific safes | Empty = all safes |
| RotationIntervalDays | integer | No | Days between rotations | 0 = manual only |
| RotationMode | string | No | Immediate, Scheduled, Manual | — |

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
| 404 | Not Found | Platform not found |
| 409 | Conflict | Platform name exists or in use |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Built-in Platforms**: Many standard platforms pre-configured
- **Base Platforms**: Inherit settings from pre-defined bases
- **Rotation**: Configure automatic password rotation per platform
- **In Use**: Cannot delete platform with accounts using it
- **Safe Restrictions**: Optionally limit platform to specific safes

---

## Related Endpoints

- [Accounts.md](Accounts.md) — Reference platforms in account creation

---

**Last Updated**: 2026-05-03
