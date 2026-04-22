# API Evaluation Workspace — AI Identity

You are operating inside the `api-evaluation` workspace. Your purpose is to maintain a **per-version reference library** of the CyberArk PAM Self-Hosted REST API — one folder per tracked version under [versions/](versions/), one markdown file per endpoint category — so that changes between versions can be evaluated and so consumers of [../cyberark-api/](../cyberark-api/) have authoritative syntax to call against.

This workspace is a **reference library, not a script generator**. It holds documentation downloaded from the CyberArk docs site and tooling to keep that documentation in sync.

## Environment

Before giving any version-dependent guidance, load [../_config/environment.md](../_config/environment.md). It declares:
- Which PVWA version is actually deployed per tier (DEV / UAT / PROD)
- Deployment model (self-hosted vs Privilege Cloud — API paths differ)
- Auth method in use

The deployed version determines which tracked `versions/vX.X.X/` folder is authoritative for the user's current environment. If the version field is blank, ask before answering version-dependent questions.

---

## Core Responsibilities

### 1. Real Data Only
- Never invent endpoints, parameters, request bodies, or response shapes
- Endpoint files are populated **only** from live CyberArk documentation at `https://docs.cyberark.com/pam-self-hosted/{major.minor}/en/content/webservices/`
- If the live docs don't show something, it doesn't go in the file
- If you are unsure, mark the field `Unknown — verify against live docs` rather than guessing

### 2. One Version Per Folder
- Each tracked version owns its own folder under [versions/](versions/): `versions/v12.2/`, `versions/v14.2.1/`, `versions/v14.4/`, etc.
- Folder name keeps the full version (`v14.2.1`), but the docs URL and catalog header use **major.minor only** (`14.2`)
- Endpoint category count is **not fixed** — it mirrors whatever CyberArk publishes for that release. New categories in later versions are added as new files; removed categories are preserved in the older version folder only.

### 3. No Cross-Workspace Duplication
- The deployed version's reference already lives at [../cyberark-api/references/api/](../cyberark-api/references/api/) in consolidated form. When a tracked version in this workspace matches the deployed version, `references/references.md` cross-links to it rather than duplicating content.
- Naming standards live at [../EVD/references/naming_standards.md](../EVD/references/naming_standards.md). Do not re-define them here.

### 4. Template Discipline
Every endpoint file must conform to [references/endpoint-template.md](references/endpoint-template.md):
- Header frontmatter: filename, version, source URL, build, status
- Overview table: `Method | Endpoint | Description | Auth Required`
- Full sections: Purpose, Full Path, HTTP Method, Auth, URL Params, Query Params, Headers, Request Body, Response, Field descriptions, Return Codes, Notes, Related Endpoints

If a section has no content for a given endpoint, write `N/A` — do not omit the section.

### 5. Script Behavior
Scripts in `scripts/` are **auxiliary**. They scaffold folders, fetch live docs, and diff versions. They are not the product. Rules:
- Destructive or file-creating scripts must support `-WhatIf` and `-Force` (via `SupportsShouldProcess`)
- Scripts normalize version input: accept `v14.2.1`, `14.2.1`, `14.2`, or `v14.2` and derive both the folder name (`v14.2.1`) and the docs URL segment (`14.2`)
- Scripts never overwrite existing populated content unless `-Force` is passed

### 6. Folder Purpose (do not cross-pollinate)
| Folder | Purpose |
|---|---|
| `reports/` | Finalized, human-shared outputs (e.g., manager reports) |
| `exports/` | Raw script output (e.g., `comparison_v12.2_to_v14.2_YYYYMMDD.md`) |
| `tmp/` | Scratch only — git-ignored |
| `versions/v{version}/` | Authoritative per-version reference content |
| `versions/version-tracking.md` | Status of every tracked version |
| `references/` | Templates and pointers — no version-specific content |

---

## Constraints

- **No direct execution of vault calls.** This workspace documents the API; it does not call it. Live vault calls belong in `../cyberark-api/` or `../psPAS/`.
- **No simulated or stub endpoint data.** If a version's folder has not yet been populated, its `endpoints/` folder contains only `README.md` pointing at the fetch script — empty is honest, fake is not.
- **Update [versions/version-tracking.md](versions/version-tracking.md) whenever a version is added, refreshed, or retired.**
- **Update [ALL-CHANGES.md](ALL-CHANGES.md)** when a Compare run identifies a material change worth surfacing at the cross-version level.

## Navigation

Read [CONTEXT.md](CONTEXT.md) in this directory for routing and integration details.
