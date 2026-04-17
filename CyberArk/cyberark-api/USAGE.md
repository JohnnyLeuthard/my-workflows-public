# CyberArk API Module — Usage Guide

## What Is This?

`cyberark-api` is a PowerShell module that calls the CyberArk PVWA REST API directly. Functions live in `module/functions/`, are auto-loaded by `module/CyberArkAPI.psm1`, and can be used interactively or by task scripts in `scripts/`.

---

## Importing the Module

```powershell
Import-Module ./module/CyberArkAPI.psd1
```

Verify it loaded:

```powershell
Get-Command -Module CyberArkAPI
```

---

## Authentication

All module functions require a `CyberArkSession` object. Create one with `Connect-CyberArkAPI`:

```powershell
$session = Connect-CyberArkAPI -BaseUrl "https://pvwa.example.com" -AuthType CyberArk
```

Pass the session to every subsequent function call:

```powershell
Get-CyberArkAccount -Session $session -SafeName "MyApp-Oracle-PROD"
```

Close the session when done:

```powershell
Disconnect-CyberArkAPI -Session $session
```

---

## Running a Task Script

Task scripts in `scripts/` wrap common operations end-to-end (auth, action, logoff). See `scripts/_INDEX.md` for the full list.

```powershell
.\scripts\Invoke-Accounts-RotateStale.ps1 -BaseUrl "https://pvwa.example.com" -SafeName "MyApp-Oracle-PROD"
```

---

## Adding a New Function

1. Identify the target API area (auth, accounts, safes, users, platforms)
2. Check `module/functions/{area}/` — does a similar function already exist?
3. **Check `references/_SOURCE.md`** to see the authoritative CyberArk docs link for your PVWA version
4. Load the relevant reference doc from `references/api/` (or consult the online docs at https://docs.cyberark.com/pam-self-hosted/14.4/)
5. Create `module/functions/{area}/Verb-CyberArkNoun.ps1`
6. The module auto-loads it on next `Import-Module`

---

## Adding a New Task Script

1. Check `scripts/_INDEX.md` — does a similar script already exist?
2. Create `scripts/{Verb}-{Area}-{Description}.ps1`
3. Update `scripts/_INDEX.md` with a one-line entry

---

## Python

Python scripts live in `scripts/python/`. They use the `requests` library and follow the same session/auth patterns as the PowerShell module. See `references/auth_methods.md` for the logon endpoint details.

---

## Environment Configuration

Before running anything, verify `../_config/environment.md` reflects your target environment. The PVWA base URL and auth method must match what's listed there.
