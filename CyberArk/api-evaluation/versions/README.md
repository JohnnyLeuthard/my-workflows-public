# versions/

Per-version reference content for the CyberArk PAM Self-Hosted REST API. One subfolder per tracked release, plus [version-tracking.md](version-tracking.md) listing the status of each.

## Layout

```
versions/
├── version-tracking.md          Status of every tracked version
└── v<version>/                  One folder per tracked release
    ├── api-catalog.md
    ├── changelog.md
    └── endpoints/
        └── <Category>.md        e.g. Accounts.md, Safes.md (populated on demand)
```

## Conventions

- Folder name keeps the full version: `v12.2`, `v14.2.1`, `v14.4.0`
- The docs URL segment inside each catalog uses major.minor only: `12.2`, `14.2`, `14.4`
- Endpoint category count is not fixed — it mirrors whatever CyberArk publishes for that release

## Adding / refreshing a version

Run from the workspace root (`api-evaluation/`):

```powershell
./scripts/New-APIVersion.ps1 -Version 14.2.1            # scaffold
./scripts/Fetch-APIDocumentation.ps1 -Version 14.2.1    # populate endpoints/
```

`New-APIVersion.ps1` appends a row to [version-tracking.md](version-tracking.md); `Fetch-APIDocumentation.ps1` updates that row with the fetch date and status.
