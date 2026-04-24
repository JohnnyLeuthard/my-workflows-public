# CyberArk API Module — AI Identity

You are operating inside the `cyberark-api` workspace. Your purpose is to help build and maintain a standardized PowerShell cmdlet collection that calls the CyberArk REST API directly — without the psPAS abstraction layer.

## Environment

Before writing any code, load `../_config/environment.md`. It defines:
- PVWA version (REST API endpoint paths and available features vary by version)
- Deployment model (self-hosted vs Privilege Cloud affects base URL and some endpoint behaviors)
- Auth method (determines which logon endpoint and parameters to use)
- Which environment tier (DEV / UAT / PROD) is in scope

Do not use API endpoints or parameters that require a higher PVWA version than listed. If the version field is blank, ask before giving version-dependent guidance.

---

## Core Responsibilities

### 1. No Redundancy
Before creating any new function, check the current inventory:
- Read `module/public/Functions/` (all subfolders) to see what already exists
- Read `module/private/Functions/` for internal helpers before writing a new one
- Read `scripts/_INDEX.md` to see existing task scripts
- If a suitable function already exists, use or extend it — do not create a duplicate

### 2. Reference First
Before writing any API call, load the relevant endpoint doc from `references/api/`:
- Read `references/api/_INDEX.md` to find the right file
- Load only the endpoint section you need — do not preload all reference files
- Do not invent endpoint paths, HTTP methods, or request body shapes

### 3. Naming Conventions
All functions must follow these patterns:

| Item | Convention | Example |
|---|---|---|
| Public functions | `Verb-CyberArkNoun` (approved PS verbs only) | `Get-CyberArkAccount` |
| Private helpers | `Verb-Noun` (no `CyberArk` prefix needed) | `Invoke-PvwaRequest` |
| Task scripts | `{Verb}-{Area}-{Description}.ps1` | `Invoke-Accounts-RotateStale.ps1` |
| Session parameter | Always named `-Session` of type `[CyberArkSession]` | |
| Output objects | `[PSCustomObject]` or typed class — never raw JSON strings | |

Use only approved PowerShell verbs. Run `Get-Verb` if unsure.

### 4. Security Guardrails
- **No plaintext credentials** anywhere in function code, scripts, or comments
- Session tokens are carried by the `CyberArkSession` class — never pass tokens as bare strings
- All API calls must use HTTPS. Flag if `-SkipCertificateCheck` is used (acceptable in DEV only)
- Do not log or output session tokens, passwords, or secret values
- Validate all user-supplied input before it reaches a URI or request body

### 5. Pipeline Alignment
- Input/output naming must stay compatible with upstream pipelines (EVD, psPAS)
- Safe names, account names, and platform IDs must conform to `../EVD/references/naming_standards.md`
- When receiving input from EVD compliance reports, preserve the field names used there

### 6. Python Support
Python is a supported secondary language. When writing Python:
- Use the `requests` library
- Follow the same session/auth pattern as the PowerShell module (no hardcoded credentials)
- Place Python files in `scripts/python/` (do not mix with PowerShell scripts)
- Flag clearly at the top of the file: `# Language: Python`

---

## Module Structure

```
module/
├── CyberArkAPI.psd1             # Manifest — version, author, exported functions
├── CyberArkAPI.psm1             # Auto-loader — loads private/ then public/
├── en-us/                       # MAML / comment-based help files
├── private/
│   └── Functions/               # Internal helpers — dot-sourced, NOT exported
│       └── (helper .ps1 files)
└── public/
    └── Functions/               # Public cmdlets — dot-sourced AND exported
        ├── Authentication/      # Connect-CyberArkAPI, Disconnect-CyberArkAPI
        ├── Accounts/            # Get/New/Set/Remove-CyberArkAccount, etc.
        ├── Safes/               # Get/New/Set/Remove-CyberArkSafe, etc.
        ├── Users/               # Get/New/Set/Remove-CyberArkUser, etc.
        ├── Platforms/           # Get/Import/Export-CyberArkPlatform, etc.
        └── Misc/                # Utility functions (e.g., Test-CyberArkConnection)
```

**Rules:**
- Public functions (exported, callable by scripts): `public/Functions/{Area}/Verb-CyberArkNoun.ps1`
- Private helpers (internal only, not exported): `private/Functions/Verb-Noun.ps1`
- The `.psm1` auto-loads both — do not manually manage imports or Edit-ModuleMember calls.

---

## Constraints

- **No direct execution**: You generate functions and scripts. The human operator runs them.
- **Review gate on destructive operations**: Any function that writes, modifies, or deletes vault objects must include a `-WhatIf` / `-Confirm` pattern (SupportsShouldProcess).
- **One concern per function**: Each function does one thing. Do not bundle auth + action into a single function.
- **Update the index**: When you add a new task script to `scripts/`, update `scripts/_INDEX.md`.

## Navigation

Read `CONTEXT.md` in this directory for pipeline routing and integration details.
