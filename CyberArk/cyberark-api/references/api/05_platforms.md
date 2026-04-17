# Platforms API Reference

> **Status: STUB** — Populate from vendor docs.
> Source: CyberArk Developer Portal → REST API → Platforms

---

## Overview

> Add summary of Platforms API scope: what a platform is, relationship to accounts (PolicyID), CPM management.

---

## Endpoints

### List Platforms

```
GET /PasswordVault/API/Platforms
```

> Query parameters (Active, PlatformType, search) — populate.

---

### Get Platform

```
GET /PasswordVault/API/Platforms/{platformId}
```

> Response shape — populate.

---

### Import Platform

```
POST /PasswordVault/API/Platforms/Import
```

> Request body (ZIP file, base64 encoded) — populate.

---

### Export Platform

```
POST /PasswordVault/API/Platforms/{platformId}/Export
```

> Response (ZIP file) — populate.

---

### Activate Platform

```
POST /PasswordVault/API/Platforms/{platformId}/Activate
```

---

### Deactivate Platform

```
POST /PasswordVault/API/Platforms/{platformId}/Deactivate
```

---

### Delete Platform

```
DELETE /PasswordVault/API/Platforms/{platformId}
```

---

## Platform Object Shape

> Populate full response object fields. Reference against EVD schema and naming_standards.md for PolicyID alignment.

| Field | Type | Notes |
|---|---|---|
| `id` | int | |
| `platformId` | string | Policy ID — must match naming_standards.md values |
| `name` | string | Display name |
| `active` | bool | |
| `platformType` | string | `Regular`, `Group`, etc. |
| `... ` | | Populate remaining fields |

---

## Version Notes

> Note which endpoints require which minimum PVWA version.
