# CyberArk Vault Automation Workspace

This workspace uses the [Model Workspace Protocol (MWP)](https://github.com/RinDig/Model-Workspace-Protocol-MWP-) to orchestrate CyberArk vault operations through folder structure and plain-text files.

**Start here**: Read `CLAUDE.md` for workspace identity, then `CONTEXT.md` for routing.

---

## First-Time Setup

Before running any pipeline, fill in your environment configuration. Claude uses this file to give version-accurate guidance — without it, it cannot know which cmdlets, API paths, or features are valid in your environment.

### 1. Open `_config/environment.md`

This file has three tables to fill in:

**Deployment Model** — for each tier (DEV / UAT / PROD), type one of:
- `Self-hosted` — you manage the vault servers on-prem
- `Privilege Cloud` — CyberArk-hosted SaaS tenant
- `N/A` — that tier doesn't exist in your environment

**Component Versions** — the DEV, UAT, and PROD columns are where you enter the version number for each component in that tier. Any component not deployed should be set to `N/A`. Pre-set `N/A` defaults (PSMP, PTA, Conjur, etc.) are intentional — leave them unless you have those components.

**Authentication** — for each tier, enter the auth method (`CyberArk`, `LDAP`, `SAML`, or `PKI`) and set MFA Enforced to `Yes` or `No`. Use `N/A` if the tier doesn't exist.

### 2. Fill in Client Tools

In the Client Tools table, add your:
- **psPAS version** — cmdlet signatures and available parameters change between versions
- **PowerShell version** — 5.1 vs 7.x affects syntax and module loading
- **Python version** — used in the EVD parsing stage

### 3. When to Update This File

Update `_config/environment.md` whenever:
- CyberArk components are upgraded
- You upgrade psPAS or PowerShell
- The workspace is handed off to someone with a different environment

### What Happens If You Skip This

Claude will ask you to fill in the file before giving version-dependent guidance. Blank version fields and unspecified environment tiers will trigger a prompt rather than a guess.

---

## Workspace Structure

| Folder | Purpose |
|--------|---------|
| `_config/` | Cross-pipeline configuration (naming standards, environment versions) |
| `EVD/` | Export Vault Data — read-only vault queries |
| `psPAS/` | PowerShell remediation — vault modifications |
