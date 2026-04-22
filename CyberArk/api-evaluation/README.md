# api-evaluation

Per-version reference library for the **CyberArk PAM Self-Hosted REST API**. One folder per tracked release; one markdown file per endpoint category.

## What it is

- A local, version-aware snapshot of the official CyberArk API docs at `https://docs.cyberark.com/pam-self-hosted/`, organized under [versions/](versions/)
- A diff tool that reports what changed between any two tracked versions
- A syntax reference for scripts built in [../cyberark-api/](../cyberark-api/) when the deployed PVWA version is not the latest

## What it is not

- Not a live API client (see [../cyberark-api/](../cyberark-api/))
- Not a remediation engine (see [../psPAS/](../psPAS/))
- Not a data pipeline (see [../EVD/](../EVD/))

## Layout

```
api-evaluation/
├── CLAUDE.md                      AI identity + protocol
├── CONTEXT.md                     Routing + inputs/outputs
├── USAGE.md                       Walkthroughs: add version / fetch / compare
├── ALL-CHANGES.md                 Curated cross-version change highlights
├── references/                    Templates + external source URLs
├── scripts/                       PowerShell utilities (auxiliary)
├── reports/                       Finalized outputs (manager reports, etc.)
├── exports/                       Raw script output
├── tmp/                           Scratch (git-ignored)
└── versions/
    ├── README.md
    ├── version-tracking.md        Which versions are tracked and their status
    └── v<version>/                One folder per tracked release
        ├── api-catalog.md
        ├── changelog.md
        └── endpoints/
            └── <Category>.md      e.g. Accounts.md, Safes.md
```

## Quick start

See [USAGE.md](USAGE.md) for the full workflow. In short:

```powershell
# Scaffold a new version
./scripts/New-APIVersion.ps1 -Version 14.2.1

# Populate it from the live CyberArk docs
./scripts/Fetch-APIDocumentation.ps1 -Version 14.2.1

# Compare two versions
./scripts/Compare-APIVersions.ps1 -From 12.2 -To 14.2.1
```

## Current status

See [versions/version-tracking.md](versions/version-tracking.md). As of the initial scaffold, only `versions/v12.2/` exists (framework only — not yet populated).
