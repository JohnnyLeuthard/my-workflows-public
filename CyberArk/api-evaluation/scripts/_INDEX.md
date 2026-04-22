# Scripts Index

Auxiliary PowerShell scripts for the `api-evaluation` workspace. These utilities scaffold, fetch, and compare — they do not call the live vault.

## Inventory

| Script | Purpose | Destructive? |
|---|---|---|
| `New-APIVersion.ps1` | Scaffold a new `versions/v{version}/` folder (api-catalog / changelog / endpoints/README) and append a row to `versions/version-tracking.md` | Creates files — supports `-WhatIf`, `-Force` |
| `Fetch-APIDocumentation.ps1` | Pull the live CyberArk docs for one version and populate `versions/v{version}/endpoints/*.md` using `../references/endpoint-template.md` | Creates/overwrites files — supports `-WhatIf`, `-Force` |
| `Compare-APIVersions.ps1` | Diff two populated version folders under `versions/` and write `exports/comparison_v{From}_to_v{To}_YYYYMMDD.md` | Writes to `exports/` — supports `-WhatIf`, `-Force` |

## Conventions

- Scripts accept version input in any of: `14.2.1`, `v14.2.1`, `14.2`, `v14.2`. They derive:
  - **Folder name:** `v14.2.1` (full version, `v` prefix)
  - **Docs URL segment:** `14.2` (major.minor only)
- Destructive scripts use `[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]`.
- Scripts never overwrite populated content unless `-Force` is passed.
- Output location:
  - `New-APIVersion.ps1` writes to `versions/v{version}/` and updates `versions/version-tracking.md`.
  - `Fetch-APIDocumentation.ps1` writes to `versions/v{version}/endpoints/`.
  - `Compare-APIVersions.ps1` writes to `exports/`.

## Running

```powershell
# From the api-evaluation/ folder
./scripts/New-APIVersion.ps1 -Version 14.2.1
./scripts/Fetch-APIDocumentation.ps1 -Version 14.2.1
./scripts/Compare-APIVersions.ps1 -From 12.2 -To 14.2.1
```

Any script accepts `-WhatIf` for a dry run.
