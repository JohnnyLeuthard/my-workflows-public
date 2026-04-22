<#
.SYNOPSIS
    Scaffold a new tracked CyberArk PAM API version folder under api-evaluation/versions/.

.DESCRIPTION
    Creates versions/v<Version>/ with api-catalog.md, changelog.md, and
    endpoints/README.md from templates. Appends a row to versions/version-tracking.md.
    Does not populate endpoint content — that happens in Fetch-APIDocumentation.ps1.

.PARAMETER Version
    Version string. Accepts 14.2.1, v14.2.1, 14.2, or v14.2. The folder name keeps
    the full version (v14.2.1); the docs URL segment uses major.minor (14.2).

.PARAMETER Force
    Overwrite an existing folder. Without -Force, the script errors if v<Version>/
    already exists.

.EXAMPLE
    ./New-APIVersion.ps1 -Version 14.2.1

.EXAMPLE
    ./New-APIVersion.ps1 -Version 14.2.1 -WhatIf

.EXAMPLE
    ./New-APIVersion.ps1 -Version 14.2.1 -Force
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidatePattern('^v?\d+\.\d+(\.\d+)?$')]
    [string]$Version,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Workspace root = parent of this script's folder
$WorkspaceRoot = Split-Path -Parent $PSScriptRoot

function ConvertTo-VersionParts {
    param([string]$Raw)
    $clean = $Raw.TrimStart('v', 'V')
    $parts = $clean.Split('.')
    [PSCustomObject]@{
        Full        = $clean                          # 14.2.1 or 14.2
        FolderName  = "v$clean"                       # v14.2.1
        MajorMinor  = "$($parts[0]).$($parts[1])"     # 14.2
    }
}

$V = ConvertTo-VersionParts -Raw $Version
$VersionsRoot = Join-Path $WorkspaceRoot 'versions'
$VersionFolder = Join-Path $VersionsRoot $V.FolderName
$EndpointsFolder = Join-Path $VersionFolder 'endpoints'
$VersionTracking = Join-Path $VersionsRoot 'version-tracking.md'

if (-not (Test-Path $VersionsRoot)) {
    if ($PSCmdlet.ShouldProcess($VersionsRoot, 'Create versions/ root')) {
        New-Item -ItemType Directory -Path $VersionsRoot -Force | Out-Null
    }
}

if (Test-Path $VersionFolder) {
    if (-not $Force) {
        throw "Folder already exists: $VersionFolder. Use -Force to overwrite."
    }
    Write-Verbose "Folder exists; -Force specified, will overwrite contents."
}

$catalogPath   = Join-Path $VersionFolder 'api-catalog.md'
$changelogPath = Join-Path $VersionFolder 'changelog.md'
$endpointsReadmePath = Join-Path $EndpointsFolder 'README.md'

$catalogContent = @"
---
version: $($V.Full)
docs_url_segment: $($V.MajorMinor)
source_url: https://docs.cyberark.com/pam-self-hosted/$($V.MajorMinor)/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm
status: Framework only
---

# v$($V.Full) — API Catalog

Category index for CyberArk PAM Self-Hosted REST API v$($V.Full).
This file is populated by ``../../scripts/Fetch-APIDocumentation.ps1 -Version $($V.Full)``.

## Categories

| Category | File | Endpoints | Notes |
|---|---|---|---|
| _(none yet — run Fetch-APIDocumentation.ps1)_ | | | |
"@

$changelogContent = @"
---
version: $($V.Full)
status: Framework only
---

# v$($V.Full) — Changelog

Version-local changelog derived from CyberArk release notes. Populated on demand —
cross-version diffs live in ``../../exports/`` and curated highlights in ``../../ALL-CHANGES.md``.

## Entries

_No entries yet._
"@

$endpointsReadmeContent = @"
# v$($V.Full) — Endpoints

This folder holds one markdown file per endpoint category for CyberArk PAM v$($V.Full).

**Currently empty.** Populate by running from the workspace root:

``````powershell
./scripts/Fetch-APIDocumentation.ps1 -Version $($V.Full)
``````

Every file written here must conform to ``../../../references/endpoint-template.md``.
"@

$plan = @(
    @{ Path = $VersionFolder;       Kind = 'Directory'; Content = $null }
    @{ Path = $EndpointsFolder;     Kind = 'Directory'; Content = $null }
    @{ Path = $catalogPath;         Kind = 'File';      Content = $catalogContent }
    @{ Path = $changelogPath;       Kind = 'File';      Content = $changelogContent }
    @{ Path = $endpointsReadmePath; Kind = 'File';      Content = $endpointsReadmeContent }
)

foreach ($item in $plan) {
    if ($item.Kind -eq 'Directory') {
        if (-not (Test-Path $item.Path)) {
            if ($PSCmdlet.ShouldProcess($item.Path, 'Create directory')) {
                New-Item -ItemType Directory -Path $item.Path -Force | Out-Null
            }
        }
    } else {
        if ($PSCmdlet.ShouldProcess($item.Path, 'Write file')) {
            Set-Content -Path $item.Path -Value $item.Content -Encoding UTF8
        }
    }
}

# Append a row to version-tracking.md if this version isn't already listed
if (Test-Path $VersionTracking) {
    $tracking = Get-Content -Path $VersionTracking -Raw
    $rowPattern = "\| $([regex]::Escape($V.Full)) \|"
    if ($tracking -notmatch $rowPattern) {
        $newRow = "| $($V.Full) | ``$($V.FolderName)/`` | unknown | ``$($V.MajorMinor)`` | Framework only | — | Added by New-APIVersion.ps1 |"
        if ($PSCmdlet.ShouldProcess($VersionTracking, "Append row for v$($V.Full)")) {
            Add-Content -Path $VersionTracking -Value $newRow
        }
    } else {
        Write-Verbose "version-tracking.md already has a row for v$($V.Full); skipping append."
    }
} else {
    Write-Warning "version-tracking.md not found at $VersionTracking — row not appended."
}

Write-Host "Scaffolded v$($V.Full) at $VersionFolder" -ForegroundColor Cyan
Write-Host "Next: populate with ./scripts/Fetch-APIDocumentation.ps1 -Version $($V.Full)" -ForegroundColor Cyan
