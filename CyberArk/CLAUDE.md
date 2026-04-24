# CyberArk Vault Automation Workspace

You are in a CyberArk operations **sub-workspace** of `my-workflows-public/`. The repo root is the top-level MWP workspace; this folder is one of its sub-workspaces. MWP is a layered context hierarchy where folder structure replaces framework-level orchestration — and it applies recursively here, so this sub-workspace has its own `CLAUDE.md` (this file) and `CONTEXT.md` that route into its sub-workspaces (EVD, psPAS, cyberark-api, api-evaluation).

## How to Navigate

Read `CONTEXT.md` in this directory to route the user's request to the correct sub-workspace. Do not load files from sub-workspaces until you have routed.

## Environment Configuration

Before making any version-sensitive suggestion (cmdlets, REST API paths, feature availability),
load `_config/environment.md`. It is the authoritative source for:
- Which CyberArk components are deployed and their versions
- Deployment model (self-hosted vs Privilege Cloud) per environment tier
- Client tool versions (psPAS, PowerShell, Python)
- Authentication methods and MFA enforcement

Do not suggest capabilities that require a higher version than listed. Do not reference
components marked `N/A`. If a version field is blank, ask before giving version-dependent guidance.

---

## Protocol Rules

See root `CLAUDE.md` for global MWP rules (route-first, layered loading, no simulated data, no inline execution code). CyberArk-specific additions:

- **Review gates**: Every stage ends with a stop. Wait for explicit human approval before proceeding to the next stage.
- **Plain text interface**: All stage communication happens through markdown and CSV files in `output/` folders.
- **Self-contained sub-workspaces**: Each sub-workspace (EVD, psPAS, cyberark-api, api-evaluation) carries its own references in its `references/` folder. Point to the owning sub-workspace's `references/` instead of duplicating. The `_config/` folder holds only cross-sub-workspace pointers (e.g., `environment.md`).
- **cyberark-api is a module, not a pipeline**: Unlike EVD (staged SQL pipeline) and psPAS (staged remediation pipeline), `cyberark-api` is a living PowerShell module. It has no fixed stage sequence — work is request-driven. MWP still applies: load `cyberark-api/CLAUDE.md` for identity, `cyberark-api/CONTEXT.md` for routing, then load only the specific `references/api/` doc needed for the current function or script. Do not preload all API reference files.
- **api-evaluation is a reference library, not an executor**: `api-evaluation` documents the REST API per PVWA version. Live calls belong in `cyberark-api` or `psPAS`.
