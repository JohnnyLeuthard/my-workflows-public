# Users & Groups API Reference

> **Status: STUB** — Populate from vendor docs.
> Source: CyberArk Developer Portal → REST API → Users / Groups

---

## Overview

> Add summary of Users API scope: vault users vs. directory users, group types, relationship to safe members.

---

## User Endpoints

### List Users

```
GET /PasswordVault/API/Users
```

> Query parameters (search, componentUser, userType) — populate.

---

### Get User

```
GET /PasswordVault/API/Users/{id}
```

> Response shape — populate.

---

### Add User

```
POST /PasswordVault/API/Users
```

> Request body — populate.

---

### Update User

```
PUT /PasswordVault/API/Users/{id}
```

> Request body — populate.

---

### Delete User

```
DELETE /PasswordVault/API/Users/{id}
```

---

### Activate User

```
POST /PasswordVault/API/Users/{id}/Activate
```

---

## Group Endpoints

### List Groups

```
GET /PasswordVault/API/UserGroups
```

> Query parameters — populate.

---

### Get Group

```
GET /PasswordVault/API/UserGroups/{groupId}
```

---

### Add Group

```
POST /PasswordVault/API/UserGroups
```

> Request body (groupName, description, location) — populate.

---

### Add Group Member

```
POST /PasswordVault/API/UserGroups/{groupId}/Members
```

> Request body — populate.

---

### Delete Group Member

```
DELETE /PasswordVault/API/UserGroups/{groupId}/Members/{username}
```

---

## User Object Shape

> Populate full response object fields. Reference against EVD schema (CAUsers table) for field alignment.

| Field | Type | Notes |
|---|---|---|
| `id` | int | Internal user ID |
| `username` | string | |
| `source` | string | `CyberArk`, `LDAP`, etc. |
| `userType` | string | |
| `componentUser` | bool | |
| `... ` | | Populate remaining fields |

---

## Version Notes

> Note which endpoints require which minimum PVWA version.
