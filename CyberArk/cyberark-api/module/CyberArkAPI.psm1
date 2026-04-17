#Requires -Version 5.1
<#
.SYNOPSIS
    CyberArkAPI — Direct REST API module for CyberArk PVWA.

.DESCRIPTION
    Auto-loads all .ps1 files from:
      private/Functions/  — internal helpers, NOT exported
      public/Functions/   — public cmdlets, exported automatically

    en-us/ holds comment-based or MAML help files for the module.

.NOTES
    Do not add function definitions directly to this file.
    Add new private helpers under private/Functions/.
    Add new public functions under public/Functions/{Area}/.
    This loader picks them up on next Import-Module — no manual registration needed.
#>

Set-StrictMode -Version Latest

#region --- Private (internal helpers — dot-sourced, not exported) ---
$PrivateFiles = @(
    Get-ChildItem -Path "$PSScriptRoot\private\Functions" -Filter '*.ps1' -Recurse -ErrorAction SilentlyContinue
)

foreach ($File in $PrivateFiles) {
    try {
        . $File.FullName
    }
    catch {
        Write-Error "CyberArkAPI: Failed to load private file '$($File.FullName)'. $_"
    }
}
#endregion

#region --- Public (exported cmdlets) ---
$PublicFiles = @(
    Get-ChildItem -Path "$PSScriptRoot\public\Functions" -Filter '*.ps1' -Recurse -ErrorAction SilentlyContinue
)

foreach ($File in $PublicFiles) {
    try {
        . $File.FullName
    }
    catch {
        Write-Error "CyberArkAPI: Failed to load public file '$($File.FullName)'. $_"
    }
}
#endregion

#region --- Export public functions only ---
Export-ModuleMember -Function ($PublicFiles.BaseName)
#endregion
