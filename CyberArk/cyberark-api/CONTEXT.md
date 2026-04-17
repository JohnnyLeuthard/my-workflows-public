# CyberArk API Module — Context & Routing

## What This Workspace Does

`cyberark-api` is a living PowerShell module that calls the CyberArk PVWA REST API directly. Unlike psPAS (which wraps the API in pre-built cmdlets), this module gives you full control over endpoint selection, request construction, and response handling.

**Use this workspace when:**
- psPAS is not available in the target environment
- You need an API operation not covered by psPAS
- You want read + write coverage via REST (psPAS is write-focused)
- You need Python-based API automation

---

## Routing

| Request type | Route |
|---|---|
| Build a new module function (e.g., "add a function to list safe members") | Load `CLAUDE.md` → check `module/functions/` inventory → load relevant `references/api/` doc → write function |
| Run a specific task (e.g., "rotate all accounts in Safe X") | Load `CLAUDE.md` → check `scripts/_INDEX.md` → generate or reuse task script |
| Add or update an API reference doc | Go to `references/api/` — add the doc, update `references/api/_INDEX.md` |
| Cross-pipeline: EVD found violations, execute via API | Receive `../EVD/stages/04_remediation/output/remediation_plan.md` → build task script in `scripts/` |
| Cross-pipeline: psPAS alternative execution | Receive `../psPAS/stages/01_planning/output/remediation_plan.md` → implement same actions via REST |

---

## Pipeline Position

```
EVD (read / analyze)
  └── stages/04_remediation/output/remediation_plan.md
        │
        ├── psPAS (write via PowerShell module wrappers)
        │
        └── cyberark-api (write via direct REST calls)  ← this workspace
```

This workspace can also operate standalone — the user describes a task directly without an upstream EVD report.

---

## Inputs

| Source | Format | Notes |
|---|---|---|
| User request (standalone) | Plain text | Describe the task; Claude will identify the right API area |
| EVD remediation plan | `remediation_plan.md` | From `../EVD/stages/04_remediation/output/` |
| psPAS planning output | `remediation_plan.md` | From `../psPAS/stages/01_planning/output/` — use as API translation target |

---

## Outputs

| Output | Location | Description |
|---|---|---|
| Module function | `module/functions/{area}/{FunctionName}.ps1` | Reusable advanced function, auto-loaded by the module |
| Task script | `scripts/{Verb}-{Area}-{Description}.ps1` | Single-purpose script using module functions |
| Python script | `scripts/python/{name}.py` | Python equivalent or supplement |
| Index update | `scripts/_INDEX.md` | Updated whenever a new task script is added |

---

## Shared References (Do Not Duplicate)

| Reference | Location | Used For |
|---|---|---|
| Environment config | `../_config/environment.md` | PVWA version, auth method, deployment model |
| Naming standards | `../EVD/references/naming_standards.md` | Safe names, account names, platform IDs |
| API endpoint docs | `references/api/` | Endpoint paths, methods, request/response shapes |
| Auth methods | `references/auth_methods.md` | Which logon endpoint to use per auth type |
| Error codes | `references/error_codes.md` | HTTP status + CyberArk error body handling |
