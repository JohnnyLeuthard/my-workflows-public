# Task Scripts Index

Scripts in this directory are single-purpose operations that use the `CyberArkAPI` module. Each script handles its own auth, performs a specific task, and closes the session.

**Before adding a new script:** Check this index to avoid duplicates. Update this file after adding any script.

---

## Python Scripts

Python scripts live in `scripts/python/`. See below.

---

## PowerShell Scripts

| Script | Area | Description |
|---|---|---|
| *(none yet)* | — | — |

---

## Python Scripts

| Script | Area | Description |
|---|---|---|
| *(none yet)* | — | — |

---

## Script Naming Convention

```
{Verb}-{Area}-{Description}.ps1
```

Examples:
- `Invoke-Accounts-RotateStale.ps1`
- `Get-Safes-MemberReport.ps1`
- `Set-Accounts-PlatformBulk.ps1`

Python scripts follow the same naming logic with `.py` extension, placed in `scripts/python/`.

---

## Script Template

Every new PowerShell task script should follow this structure:

```powershell
#Requires -Modules CyberArkAPI
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [string] $BaseUrl,
    [Parameter(Mandatory)] [string] $AuthType
    # ... task-specific parameters
)

$session = Connect-CyberArkAPI -BaseUrl $BaseUrl -AuthType $AuthType
try {
    # ... task logic using module functions
}
finally {
    Disconnect-CyberArkAPI -Session $session
}
```
