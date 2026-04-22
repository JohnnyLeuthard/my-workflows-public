# api-evaluation — Usage

Walkthroughs for the three things this workspace does: track a new version, refresh an existing version, compare two versions.

## 1. Add a new tracked version

```powershell
./scripts/New-APIVersion.ps1 -Version 14.2.1
```

What it does:
- Validates the version against `^v?\d+\.\d+(\.\d+)?$`
- Creates `versions/v14.2.1/` with `api-catalog.md`, `changelog.md`, and `endpoints/README.md`
- Appends a row to `versions/version-tracking.md` with status `Framework only`
- Accepts `-WhatIf` for a dry run and `-Force` to overwrite an existing folder

The folder is **empty of endpoint content** until you run the fetch step below.

## 2. Populate / refresh endpoint docs

```powershell
./scripts/Fetch-APIDocumentation.ps1 -Version 14.2.1
./scripts/Fetch-APIDocumentation.ps1 -Version 14.2.1 -Force    # re-fetch + overwrite
```

What it does:
- Normalizes `14.2.1` → docs URL segment `14.2` (major.minor only)
- Pulls the webservices landing page at `https://docs.cyberark.com/pam-self-hosted/14.2/en/content/webservices/`
- Enumerates endpoint category pages linked from the landing page
- Writes one file per category under `versions/v14.2.1/endpoints/`, formatted per [references/endpoint-template.md](references/endpoint-template.md)
- Updates `versions/v14.2.1/api-catalog.md` with the category list actually published by CyberArk for that version
- Updates `versions/version-tracking.md` with the fetch date and status `Populated`

Endpoint counts are **not fixed**. CyberArk adds/removes categories across releases — the folder reflects reality, not a template.

## 3. Compare two versions

```powershell
./scripts/Compare-APIVersions.ps1 -From 12.2 -To 14.2.1
```

What it does:
- Walks `versions/v12.2/endpoints/` and `versions/v14.2.1/endpoints/`
- Identifies Added categories, Removed categories, and Modified categories (category exists in both but overview table differs)
- Writes `exports/comparison_v12.2_to_v14.2.1_YYYYMMDD.md` using [references/version-comparison-template.md](references/version-comparison-template.md)

Both versions must be populated first. If either is `Framework only` in `versions/version-tracking.md`, the script will warn and exit.

## 4. Produce a manager report

Not automated — take the comparison export, re-author through [references/manager-report-template.md](references/manager-report-template.md), save under `reports/`. Focus on API changes only; ignore documentation-only differences (whitespace, wording).

---

## Conventions

- **Folder name** keeps the full version: `v14.2.1`
- **Docs URL segment** is major.minor only: `14.2`
- **Export filename** keeps the full version: `comparison_v12.2_to_v14.2.1_20260422.md`
- Scripts never overwrite populated content without `-Force`
- `tmp/` is for scratch; content there is git-ignored and should not be committed
