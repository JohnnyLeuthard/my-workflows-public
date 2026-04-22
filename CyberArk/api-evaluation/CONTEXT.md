# API Evaluation — Context & Routing

## What This Workspace Does

`api-evaluation` is a **per-version reference library** for the CyberArk PAM Self-Hosted REST API. For each tracked release under [versions/](versions/) (e.g., `versions/v12.2/`, `versions/v14.2.1/`, `versions/v14.4/`), it holds one markdown file per endpoint category, populated from the official CyberArk documentation. Its two jobs:

1. Let a user compare API surface area across versions (Added / Removed / Modified endpoints).
2. Serve as a local syntax reference for consumers of [../cyberark-api/](../cyberark-api/) when building scripts that must target a specific PVWA version.

**Use this workspace when:**
- You need to know whether an endpoint exists in version X
- You need to see how a request/response shape changed between versions
- You are upgrading / planning an upgrade and need an API impact assessment
- A `cyberark-api` function needs an authoritative reference for a non-current PVWA version

**Do not use this workspace for:**
- Calling the live API (→ `../cyberark-api/`)
- Executing vault changes (→ `../psPAS/` or `../cyberark-api/`)
- Querying vault data (→ `../EVD/`)

---

## Routing

| Request type | Route |
|---|---|
| "Does endpoint X exist in v14.2.1?" | Open `versions/v14.2.1/api-catalog.md` → locate category → open `versions/v14.2.1/endpoints/{Category}.md` |
| "Add a new tracked version" | Run `scripts/New-APIVersion.ps1 -Version X.X.X`, then `scripts/Fetch-APIDocumentation.ps1 -Version X.X.X` |
| "Refresh an existing version's docs" | Run `scripts/Fetch-APIDocumentation.ps1 -Version X.X.X -Force` |
| "Compare version A vs B" | Run `scripts/Compare-APIVersions.ps1 -From A -To B` → output lands in `exports/` |
| "Generate a manager report from a comparison" | Take the `exports/comparison_*.md`, apply `references/manager-report-template.md`, save to `reports/` |
| Cross-pipeline: `cyberark-api` function needs a non-deployed version's shape | Load the matching `versions/v{version}/endpoints/{Category}.md` — do not copy it into `cyberark-api/references/` |

---

## Inputs

| Source | Format | Notes |
|---|---|---|
| Live CyberArk docs | HTML | `https://docs.cyberark.com/pam-self-hosted/{major.minor}/en/content/webservices/` — source of truth |
| User version request | plain text | User specifies a version; scripts normalize and validate |

## Outputs

| Output | Location | Description |
|---|---|---|
| Per-version catalog | `versions/v{version}/api-catalog.md` | Category index for that version |
| Per-version changelog | `versions/v{version}/changelog.md` | Version-local changelog (from vendor release notes) |
| Per-endpoint-category doc | `versions/v{version}/endpoints/{Category}.md` | Full endpoint reference conforming to `references/endpoint-template.md` |
| Comparison export | `exports/comparison_v{A}_to_v{B}_YYYYMMDD.md` | Raw diff output from `Compare-APIVersions.ps1` |
| Manager report | `reports/{name}.md` | Executive-facing write-up of a comparison |
| Version status | `versions/version-tracking.md` | Which versions tracked, their status, last-fetched date |
| Master change log | `ALL-CHANGES.md` | Curated cross-version highlights |

---

## Shared References (Do Not Duplicate)

| Reference | Location | Used For |
|---|---|---|
| Environment config | [../_config/environment.md](../_config/environment.md) | Identifies the deployed PVWA version — tells you which `versions/v{version}/` folder is "current" |
| Naming standards | [../EVD/references/naming_standards.md](../EVD/references/naming_standards.md) | Safe names, account names, platform IDs — do not redefine here |
| Deployed-version API reference | [../cyberark-api/references/api/](../cyberark-api/references/api/) | Consolidated reference for the currently deployed version. When a `versions/v{version}/` here matches the deployed version, prefer the consolidated form for active scripting; this workspace remains the per-version historical record |
| Auth methods | [../cyberark-api/references/auth_methods.md](../cyberark-api/references/auth_methods.md) | Logon endpoint per auth type |
| Error codes | [../cyberark-api/references/error_codes.md](../cyberark-api/references/error_codes.md) | HTTP status + CyberArk error body handling |
