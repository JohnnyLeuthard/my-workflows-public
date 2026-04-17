# API Endpoint Reference Index

CyberArk PVWA REST API (v14.4) — endpoint docs organized by functional area. Load only the file relevant to the task at hand.

> **Before creating or updating API functions**, read `../_SOURCE.md` to see the authoritative docs link and version info. External docs at https://docs.cyberark.com/pam-self-hosted/14.4/ are the single source of truth — local files here are cached snapshots.

## Endpoint Areas

| File | Area | Key Operations |
|---|---|---|
| `01_auth.md` | Authentication | Logon, Logoff, session token management |
| `02_accounts.md` | Accounts | List, Get, Add, Update, Delete, Verify, Change/Reconcile, Rotate |
| `03_safes.md` | Safes | List, Get, Add, Update, Delete, Members (add/get/update/delete) |
| `04_users.md` | Users & Groups | List users/groups, Get, Add, Update, Delete, Group membership |
| `05_platforms.md` | Platforms | List, Get, Import, Export, Activate, Deactivate |
| `06_system_health.md` | System Health | Component status, Vault health summary |

## Base URL Pattern

```
https://{pvwa_hostname}/PasswordVault/API/{endpoint}
```

The base URL (`pvwa_hostname`) comes from `../../_config/environment.md`. Always read it from there — do not hardcode.

## API Version Notes

> Populate this section from vendor docs as each area is walked through.

| API Area | Minimum PVWA Version | Notes |
|---|---|---|
| Auth | — | — |
| Accounts | — | — |
| Safes | — | — |
| Users | — | — |
| Platforms | — | — |
| System Health | — | — |

## Common Headers

| Header | Value | Required |
|---|---|---|
| `Content-Type` | `application/json` | On POST/PUT/PATCH |
| `Authorization` | Session token from logon | All authenticated endpoints |

> Exact header name and token format — populate from vendor docs.
