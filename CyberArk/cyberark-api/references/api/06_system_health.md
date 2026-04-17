# System Health API Reference

> **Status: STUB** — Populate from vendor docs.
> Source: CyberArk Developer Portal → REST API → System Health

---

## Overview

> Add summary of System Health API scope: which components are reported, what "healthy" looks like, use cases (monitoring, pre-flight checks before operations).

---

## Endpoints

### Get System Health Summary

```
GET /PasswordVault/API/ComponentsMonitoringSummary
```

> Response shape — populate. Covers: Vault, PVWA, CPM, PSM, PSMP, PTA.

---

### Get Component Details

```
GET /PasswordVault/API/ComponentsMonitoringDetails/{componentId}
```

> Path parameter values (`Vault`, `PVWA`, `SessionManagement`, etc.) — populate.
> Response shape — populate.

---

## Component Status Shape

> Populate full response object.

| Field | Type | Notes |
|---|---|---|
| `component` | string | Component name |
| `componentVersion` | string | |
| `connected` | bool | |
| `lastLogonDate` | int | Unix epoch |
| `... ` | | Populate remaining fields |

---

## Common Health Check Pattern

> Document the recommended pre-flight check pattern used by task scripts:
> - Verify PVWA is reachable
> - Verify CPM is connected (before triggering rotations)
> - Verify PSM is connected (before launching sessions)

---

## Version Notes

> Note which endpoints require which minimum PVWA version.
