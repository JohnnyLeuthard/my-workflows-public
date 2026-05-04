<#
.SYNOPSIS
Creates a new API version folder structure for documentation.

.DESCRIPTION
Sets up a complete folder structure for a new CyberArk API version, including:
- Folder creation (self-hosted/vX.X/endpoints/ or privilege-cloud/vX.X/endpoints/)
- api-catalog.md (endpoint overview)
- changelog.md (version changes)
- cumulative-changes.md (changes since baseline)
- Endpoint stub files (copies from source version if available)

.PARAMETER Version
The new version to create (e.g., '14.2', '14.4', '24.1').
Must be in the format X.X or X.X.X (script normalizes).

.PARAMETER Platform
Target platform: 'SH' (Self-Hosted, default) or 'PC' (Privilege Cloud).

.PARAMETER CopyFrom
Source version to copy endpoint stubs from (default: 12.2 for SH, none for PC).
Use this to bootstrap a new version from an existing one.

.PARAMETER WhatIf
Preview what would be created without creating files.

.PARAMETER Force
Skip confirmation prompts and proceed with creation.

.EXAMPLE
.\New-APIVersion.ps1 -Version 14.4

Creates self-hosted/v14.4 folder structure, copying endpoint stubs from v12.2.

.EXAMPLE
.\New-APIVersion.ps1 -Version 14.4 -Platform PC

Creates privilege-cloud/v14.4 folder structure (no copy).

.EXAMPLE
.\New-APIVersion.ps1 -Version 14.4 -CopyFrom 14.2 -Force

Creates self-hosted/v14.4, copying from self-hosted/v14.2 without confirmation.

.NOTES
- Endpoint stubs are copied from the source version if it exists
- Each file is created with the appropriate version number and platform
- Platform field is inserted into all copied endpoint file headers
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [ValidateSet('SH', 'PC')]
    [string]$Platform = 'SH',

    [string]$CopyFrom,

    [switch]$WhatIf,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# Normalize version (v14.2 -> 14.2)
$Version = $Version -replace '^v', ''
$CopyFrom = $CopyFrom -replace '^v', ''

# Set default CopyFrom per platform
if ([string]::IsNullOrEmpty($CopyFrom)) {
    $CopyFrom = if ($Platform -eq 'PC') { $null } else { '12.2' }
}

# Validate version format
if ($Version -notmatch '^\d+\.\d+(\.\d+)?$') {
    Write-Error "Invalid version format. Use X.X or X.X.X (e.g., '14.2')"
    exit 1
}

# Resolve script paths
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptRoot

# Platform folder resolution
$PlatformFolder = if ($Platform -eq 'PC') { 'privilege-cloud' } else { 'self-hosted' }
$VersionFolder = Join-Path $RepoRoot "versions" $PlatformFolder "v$Version"
$EndpointsFolder = Join-Path $VersionFolder "endpoints"

# Source version folder (for copying)
if ($CopyFrom) {
    $SourcePlatformFolder = if ($Platform -eq 'PC') { 'privilege-cloud' } else { 'self-hosted' }
    $CopyFromFolder = Join-Path $RepoRoot "versions" $SourcePlatformFolder "v$CopyFrom"
} else {
    $CopyFromFolder = $null
}

# Docs URL per platform
$DocsBase = if ($Platform -eq 'PC') {
    "https://docs.cyberark.com/privilege-cloud-standard/latest"
} else {
    "https://docs.cyberark.com/pam-self-hosted/$($Version.Substring(0, $Version.LastIndexOf('.')))"
}

Write-Host "CyberArk API Version Creator" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Platform:       $Platform ($PlatformFolder)"
Write-Host "New Version:    $Version"
if ($CopyFrom) { Write-Host "Copy From:      $CopyFrom" }
Write-Host "Folder:         $VersionFolder"
Write-Host "Docs Base:      $DocsBase"
Write-Host ""

# Check if version already exists
if (Test-Path $VersionFolder) {
    Write-Error "Version folder already exists: $VersionFolder"
    exit 1
}

# Check if source version exists (for copying)
$skipCopy = $false
if ($CopyFrom) {
    if (-not (Test-Path $CopyFromFolder)) {
        Write-Warning "Source version folder not found: $CopyFromFolder"
        Write-Host "Endpoint stubs will NOT be copied (you'll need to populate manually)"
        $skipCopy = $true
    }
}

# Confirm action
if (-not $WhatIf -and -not $Force) {
    Write-Host "This will:"
    Write-Host "  1. Create folder: $VersionFolder"
    Write-Host "  2. Create endpoints subfolder: $EndpointsFolder"
    Write-Host "  3. Create api-catalog.md"
    Write-Host "  4. Create changelog.md"
    if (-not $skipCopy -and $CopyFrom) {
        Write-Host "  5. Copy endpoint stubs from $CopyFrom"
    }
    Write-Host ""
    $response = Read-Host "Continue? (y/n)"
    if ($response -ne 'y') {
        Write-Host "Cancelled."
        exit 0
    }
}

if ($WhatIf) {
    Write-Host "[WhatIf] Would create folder structure for $Platform v$Version" -ForegroundColor Yellow
    Write-Host "[WhatIf] Would create:" -ForegroundColor Yellow
    Write-Host "[WhatIf]   - $VersionFolder" -ForegroundColor Yellow
    Write-Host "[WhatIf]   - $EndpointsFolder" -ForegroundColor Yellow
    Write-Host "[WhatIf]   - api-catalog.md" -ForegroundColor Yellow
    Write-Host "[WhatIf]   - changelog.md" -ForegroundColor Yellow
    if (-not $skipCopy -and $CopyFrom) {
        Write-Host "[WhatIf]   - Endpoint stubs copied from v$CopyFrom" -ForegroundColor Yellow
    }
    exit 0
}

# Create folders
Write-Host "Creating folder structure..." -ForegroundColor Green
New-Item -ItemType Directory -Path $VersionFolder -Force | Out-Null
New-Item -ItemType Directory -Path $EndpointsFolder -Force | Out-Null
Write-Host "✓ Folders created" -ForegroundColor Green

# Create api-catalog.md
$catalogContent = @"
# CyberArk PAM REST API [$($Platform)] v$Version — Endpoint Catalog

| Field | Value |
|-------|-------|
| **Version** | $Version |
| **Platform** | $(if ($Platform -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' }) |
| **Status** | Structure created; awaiting endpoint documentation |
| **Source** | $DocsBase |

---

This folder is under construction. See parent [version-tracking.md](../version-tracking.md) for completion status.

---

**Last Updated**: $(Get-Date -Format 'yyyy-MM-dd')
"@

$catalogContent | Set-Content -Path (Join-Path $VersionFolder "api-catalog.md") -Encoding UTF8
Write-Host "✓ api-catalog.md created" -ForegroundColor Green

# Create changelog.md
$changelogContent = @"
# Changelog — [$($Platform)] v$Version

**Version**: $Version
**Platform**: $(if ($Platform -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' })
**Status**: Documentation in progress

---

## Changes vs v$CopyFrom

(To be documented — compare endpoint structures and note any new/modified/removed endpoints)

---

**Last Updated**: $(Get-Date -Format 'yyyy-MM-dd')
"@

$changelogContent | Set-Content -Path (Join-Path $VersionFolder "changelog.md") -Encoding UTF8
Write-Host "✓ changelog.md created" -ForegroundColor Green

# Create endpoints/README.md
$endpointReadmeContent = @"
# v$Version Endpoints — [$($Platform)]

This folder contains endpoint documentation for CyberArk PAM [$($Platform)] v$Version.

**Status**: Awaiting endpoint documentation

## Process

1. Create endpoint files following the template in \`../../references/endpoint-template.md\`
2. Name each file: \`[EndpointName].md\` (e.g., \`Accounts.md\`, \`Users.md\`)
3. Fill in all 12 required sections (Header through Example Usage)
4. Set \`Platform | $(if ($Platform -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' })\` in file header
5. Validate completeness — no stubs, TODOs, or "Partial" status

## Reference

- Template: \`../../references/endpoint-template.md\`
- Example (v12.2): \`../self-hosted/v12.2/endpoints/Accounts.md\`
- Tracking: \`../version-tracking.md\`

---

**Last Updated**: $(Get-Date -Format 'yyyy-MM-dd')
"@

$endpointReadmeContent | Set-Content -Path (Join-Path $EndpointsFolder "README.md") -Encoding UTF8
Write-Host "✓ endpoints/README.md created" -ForegroundColor Green

# Copy endpoint stubs from source version if available
if (-not $skipCopy -and $CopyFrom) {
    Write-Host "Copying endpoint stubs from $CopyFrom..." -ForegroundColor Green

    $sourceEndpointsFolder = Join-Path $CopyFromFolder "endpoints"
    $endpointFiles = @(Get-ChildItem -Path $sourceEndpointsFolder -Filter "*.md" -Exclude "README.md" -ErrorAction SilentlyContinue)

    foreach ($file in $endpointFiles) {
        $content = Get-Content -Path $file.FullName -Raw

        # Update version number in the copied file
        $content = $content -replace "(?<=\| \*\*Version\*\* \| )$CopyFrom", $Version

        # Update platform field if it exists; if not, add it after Version row
        if ($content -match '\| \*\*Platform\*\* \|') {
            $platformLabel = if ($Platform -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' }
            $content = $content -replace '(?<=\| \*\*Platform\*\* \| ).*?(?= \|)', $platformLabel
        } else {
            $platformLabel = if ($Platform -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' }
            $content = $content -replace "((?<=\| \*\*Version\*\* \| $Version \|)\n)", "`n| **Platform** | $platformLabel |`n"
        }

        $outPath = Join-Path $EndpointsFolder $file.Name
        $content | Set-Content -Path $outPath -Encoding UTF8
        Write-Host "  ✓ $($file.Name)" -ForegroundColor Gray
    }

    Write-Host "✓ Endpoint stubs copied ($($endpointFiles.Count) files)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Summary" -ForegroundColor Green
Write-Host "=======" -ForegroundColor Green
Write-Host "Created: [$Platform] v$Version"
Write-Host "Location: $VersionFolder"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan

$platformLabel = if ($Platform -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' }

if ($skipCopy -or -not $CopyFrom) {
    Write-Host "  1. Manually create endpoint files in $EndpointsFolder"
} else {
    Write-Host "  1. Review and update endpoint files copied from $CopyFrom"
    Write-Host "  2. Update Platform field in headers to '$platformLabel'"
}
Write-Host "  3. Update changelog.md with changes in this version"
Write-Host "  4. Update ../version-tracking.md with completion status"
Write-Host "  5. Use Compare-APIVersions.ps1 to generate version diff reports"
Write-Host ""
Write-Host "Template: ../../references/endpoint-template.md" -ForegroundColor Gray
Write-Host "Docs: $DocsBase" -ForegroundColor Gray
