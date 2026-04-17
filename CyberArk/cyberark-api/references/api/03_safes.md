# Safes API Reference

> **Status: PARTIAL**
> **Source:** https://docs.cyberark.com/pam-self-hosted/14.4/en/content/webservices/safe-management.htm
> **Version:** 14.4 | **Last Updated:** 2026-04-16

---

## Overview

A **safe** is a container for credential objects (accounts) in CyberArk. Each account belongs to exactly one safe. Safes define:
- **Membership** — which vault users have access and what permissions they have
- **Retention policies** — how long accounts and versions are kept
- **Security settings** — object-level access control (OLAC), CPM management
- **Audit scope** — safes are the primary unit for access control and logging

The Safes API provides full CRUD access to safes and their membership.

---

## Endpoints

### List Safes
GET /PasswordVault/API/Safes

**Minimum PVWA version:** 9.10+

**Query Parameters**
| Parameter | Type | Required | Description |
|---|---|---|---|
| `search` | string | No | Search by safe name (substring match) |
| `offset` | int | No | Pagination offset (default: 0) |
| `limit` | int | No | Results per page (default: 25, max: 1000) |
| `sort` | string | No | Sort field (e.g., `safeName`, `creationTime`) |
| `includeAccounts` | bool | No | Include account list in each safe (default: false) |

**Response**

```json
{
  "safes": [
    {
      "safeUrlId": "1",
      "safeName": "App-Oracle-PROD",
      "description": "Production Oracle database accounts",
      "location": "/",
      "creationTime": 1609459200,
      "createdBy": "admin",
      "numberOfDaysRetention": 90,
      "numberOfVersionsRetention": 5,
      "olacEnabled": false,
      "managingCPM": "CPM-Prod",
      "accountCount": 12
    }
  ],
  "count": 1
}
```

**Notes**
- Pagination defaults apply if offset/limit not specified
- `search` is case-insensitive substring match

---

### Get Safe
GET /PasswordVault/API/Safes/{safeName}

**Minimum PVWA version:** 9.10+

**Path Parameters**
| Parameter | Type | Description |
|---|---|---|
| `safeName` | string | Safe name (URL-encoded) |

**Response**

```json
{
  "safeUrlId": "1",
  "safeName": "App-Oracle-PROD",
  "description": "Production Oracle database accounts",
  "location": "/",
  "creationTime": 1609459200,
  "createdBy": "admin",
  "numberOfDaysRetention": 90,
  "numberOfVersionsRetention": 5,
  "olacEnabled": false,
  "managingCPM": "CPM-Prod",
  "accountCount": 12,
  "lastModificationTime": 1609459300,
  "lastModifiedBy": "dba-team"
}
```

**Notes**
- Safe names with special characters must be URL-encoded

---

### Add Safe
POST /PasswordVault/API/Safes

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `safeName` | string | Yes | Unique safe name |
| `description` | string | No | Safe description/purpose |
| `location` | string | No | Vault folder location (default: `/`) |
| `numberOfDaysRetention` | int | No | Retention days (default: 7) |
| `numberOfVersionsRetention` | int | No | Number of password versions to keep (default: 5) |
| `olacEnabled` | bool | No | Enable object-level access control (default: false) |
| `managingCPM` | string | No | CPM name for auto password changes (default: none) |

**Example**

```json
{
  "safeName": "App-Oracle-PROD",
  "description": "Production Oracle database accounts",
  "numberOfDaysRetention": 90,
  "numberOfVersionsRetention": 10,
  "managingCPM": "CPM-Prod"
}
```

**Response**

Returns the new safe object with assigned `safeUrlId`.

**Notes**
- Safe names must be unique and follow naming standards
- OLAC enables fine-grained member permissions per account
- CPM name must exist in the vault

---

### Update Safe
PUT /PasswordVault/API/Safes/{safeName}

**Minimum PVWA version:** 9.10+

**Request Body**

Same as Add Safe — all updatable fields.

```json
{
  "description": "Updated description",
  "numberOfDaysRetention": 120,
  "managingCPM": "CPM-Prod"
}
```

**Notes**
- Cannot change `safeName` after creation
- Partial updates are allowed

---

### Delete Safe
DELETE /PasswordVault/API/Safes/{safeName}

**Minimum PVWA version:** 9.10+

**Response:** `204 No Content`

**Notes**
- Safe must be empty (no accounts) to delete
- Operation is permanent and cannot be reversed
- Only vault admins or safe owners can perform this

---

## Safe Members

### List Safe Members
GET /PasswordVault/API/Safes/{safeName}/Members

**Minimum PVWA version:** 9.10+

**Query Parameters**
| Parameter | Type | Required | Description |
|---|---|---|---|
| `offset` | int | No | Pagination offset |
| `limit` | int | No | Results per page |
| `search` | string | No | Filter by member name |

**Response**

```json
{
  "members": [
    {
      "memberName": "admin",
      "memberType": "User",
      "membershipExpirationDate": null,
      "permissions": {
        "useAccounts": true,
        "retrieveAccounts": true,
        "listAccounts": true,
        "addAccounts": true,
        "updateAccountContent": true,
        "updateAccountProperties": true,
        "initiateCPMAccountManagementOperations": true,
        "specifyNextAccountContent": true,
        "renameAccounts": true,
        "deleteAccounts": true,
        "unlockAccounts": true,
        "manageSafeMembers": true,
        "manageSafe": true,
        "validateSafeContent": true,
        "authorizeAccountRequests": true,
        "administer": true
      }
    }
  ],
  "count": 1
}
```

---

### Add Safe Member
POST /PasswordVault/API/Safes/{safeName}/Members

**Minimum PVWA version:** 9.10+

**Request Body**
| Field | Type | Required | Description |
|---|---|---|---|
| `memberName` | string | Yes | Vault user or group name |
| `memberType` | string | Yes | `User` or `Group` |
| `membershipExpirationDate` | int | No | Unix timestamp when membership expires |
| `permissions` | object | Yes | Permissions object (see table below) |

**Permissions Object**

| Field | Type | Description |
|---|---|---|
| `useAccounts` | bool | Use (logon to) accounts in safe |
| `retrieveAccounts` | bool | View/copy password values |
| `listAccounts` | bool | List accounts in safe |
| `addAccounts` | bool | Create new accounts |
| `updateAccountContent` | bool | Change password values |
| `updateAccountProperties` | bool | Modify account metadata |
| `initiateCPMAccountManagementOperations` | bool | Trigger CPM verify/change |
| `specifyNextAccountContent` | bool | Set next password via API |
| `renameAccounts` | bool | Rename accounts |
| `deleteAccounts` | bool | Delete accounts |
| `unlockAccounts` | bool | Unlock locked accounts |
| `manageSafeMembers` | bool | Add/remove safe members |
| `manageSafe` | bool | Edit safe properties |
| `validateSafeContent` | bool | Run safe audit checks |
| `authorizeAccountRequests` | bool | Approve access requests |
| `administer` | bool | Full administrative access |

**Example**

```json
{
  "memberName": "dba-team",
  "memberType": "Group",
  "permissions": {
    "useAccounts": true,
    "retrieveAccounts": true,
    "listAccounts": true,
    "addAccounts": true,
    "updateAccountContent": true,
    "initiateCPMAccountManagementOperations": true,
    "manageSafeMembers": false,
    "manageSafe": false,
    "administer": false
  }
}
```

**Notes**
- `memberName` must be an existing vault user or group
- Leave `membershipExpirationDate` null or omit for permanent membership
- Grant only the minimum permissions needed (principle of least privilege)

---

### Update Safe Member
PUT /PasswordVault/API/Safes/{safeName}/Members/{memberName}

**Minimum PVWA version:** 9.10+

**Request Body**

Permissions object (same structure as Add Safe Member).

```json
{
  "permissions": {
    "useAccounts": true,
    "retrieveAccounts": false,
    "listAccounts": true
  }
}
```

---

### Delete Safe Member
DELETE /PasswordVault/API/Safes/{safeName}/Members/{memberName}

**Minimum PVWA version:** 9.10+

**Response:** `204 No Content`

**Notes**
- Removes the user/group from the safe immediately
- The user loses access to all accounts in the safe

---

## Safe Object Reference

**Common fields in safe objects:**

| Field | Type | Description |
|---|---|---|
| `safeUrlId` | string | Internal CyberArk safe ID (URL-safe) |
| `safeName` | string | Display safe name |
| `description` | string | Safe description/purpose |
| `location` | string | Vault location path |
| `creationTime` | int | Unix timestamp of creation |
| `createdBy` | string | Creator username |
| `lastModificationTime` | int | Unix timestamp of last update |
| `lastModifiedBy` | string | Last modifier username |
| `numberOfDaysRetention` | int | Password version retention days |
| `numberOfVersionsRetention` | int | Number of password versions kept |
| `olacEnabled` | bool | Object-level access control enabled |
| `managingCPM` | string | CPM name managing auto-changes |
| `accountCount` | int | Number of accounts in safe |

---

## Common Error Responses

| Status | Cause | Resolution |
|---|---|---|
| 400 | Safe name already exists | Use unique name |
| 400 | Invalid permission flag name | Check permissions object syntax |
| 403 | Insufficient vault permissions | Contact vault admin |
| 404 | Safe does not exist | Verify safe name (URL-encode if needed) |
| 409 | Safe name conflict | Another safe already has this name |

---

## Version Notes

| Feature | Minimum Version | Notes |
|---|---|---|
| Basic safe CRUD | 9.10 | Create, read, update, delete safes |
| Safe members management | 9.10 | Add, list, update, delete safe members |
| OLAC (object-level access control) | 10.x+ | Fine-grained account-level permissions |
| CPM management integration | 9.10 | Assign managing CPM to safe |
| Safe retention policies | 9.10 | Password version and day retention |
