# Groups

## Header

| Field | Value |
|-------|-------|
| **File** | Groups.md |
| **Version** | 12.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build** | 8.2.5 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/Groups |
| **Description** | Manage vault user groups |
| **Auth Required** | Yes (Vault Admin) |

---

## Purpose

Create and manage user groups for role-based access control. Assign permissions to groups instead of individual users for easier management.

---

## Full Path

```
GET /api/Groups
GET /api/Groups/{GroupID}
POST /api/Groups
PUT /api/Groups/{GroupID}
DELETE /api/Groups/{GroupID}
```

---

## HTTP Method

### GET - List/Retrieve Groups
- **Purpose**: List groups or get group details
- **Body**: None
- **Response**: JSON group(s)

### POST - Create Group
- **Purpose**: Create new group
- **Body**: JSON group properties
- **Response**: JSON created group

### PUT - Update Group
- **Purpose**: Update group properties
- **Body**: JSON updates
- **Response**: JSON updated group

### DELETE - Delete Group
- **Purpose**: Remove group
- **Body**: None
- **Response**: HTTP 204

---

## Authentication

**Required**: Yes — Vault Admin

```
Authorization: CyberArk <admin_token>
```

---

## Request Body

```json
{
  "GroupName": "SecurityOps",
  "Description": "Security Operations Team"
}
```

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| GroupName | string | Yes | Group name | Unique |
| Description | string | No | Group description | — |

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
| 404 | Not Found | Group not found |
| 409 | Conflict | Group name exists |
| 500 | Internal Server Error | Vault error |

---

## Notes

- **LDAP Integration**: Can map LDAP groups to vault groups
- **Permissions**: Assign safe/account permissions to groups
- **Members**: Add users to groups via Users endpoint

---

## Related Endpoints

- [Users.md](Users.md) — Manage group members

---

**Last Updated**: 2026-05-03
