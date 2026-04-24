# References Index

Load reference files **on demand** — only load what the current task requires. Do not preload all files.

> **Before creating or updating API functions**, read `_SOURCE.md` to see the authoritative docs link and versioning status. Local files are cached snapshots — the external docs are the single source of truth.

## When to Load Each File

| File | Load When... |
|---|---|
| `api/_INDEX.md` | Before any API call — identifies which endpoint doc to load |
| `api/01_auth.md` | Writing or debugging auth/session functions |
| `api/02_accounts.md` | Working with account objects (get, add, update, delete, rotate, reconcile, verify) |
| `api/03_safes.md` | Working with safes or safe members |
| `api/04_users.md` | Working with vault users or groups |
| `api/05_platforms.md` | Working with platforms or platform configuration |
| `api/06_system_health.md` | Checking component health or system status |
| `auth_methods.md` | Choosing or implementing a logon method (CyberArk, LDAP, RADIUS, SAML, PKI) |
| `error_codes.md` | Handling API errors, writing error handling logic, diagnosing failed calls |

