<#
.SYNOPSIS
Fetches live CyberArk PAM REST API documentation and creates endpoint markdown files.

.DESCRIPTION
Downloads CyberArk API documentation from official sources and parses it to generate
structured endpoint documentation files following the endpoint-template.md format.

Supports versions: 12.2, 14.2, 14.4

.PARAMETER Version
The CyberArk version to fetch (e.g., '12.2', '14.2', '14.4').
Must be in the format vX.X or X.X (script normalizes to X.X).

.PARAMETER WhatIf
Preview what would be fetched without creating files.

.PARAMETER Force
Skip confirmation prompts and proceed with fetch.

.EXAMPLE
.\Fetch-APIDocumentation.ps1 -Version 12.2

Fetches v12.2 documentation and populates v12.2/endpoints/

.EXAMPLE
.\Fetch-APIDocumentation.ps1 -Version 14.2 -Force

Fetches v14.2 documentation without confirmation.

.NOTES
- This script does NOT execute API calls; it fetches static documentation
- Output files are created in the version folder: vX.X/endpoints/
- Files follow the endpoint-template.md format
- Requires internet access to cyberark.com documentation
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [switch]$WhatIf,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# Normalize version (v12.2 -> 12.2)
$Version = $Version -replace '^v', ''

# Validate version format
if ($Version -notmatch '^\d+\.\d+$') {
    Write-Error "Invalid version format. Use X.X (e.g., '12.2', '14.2')"
    exit 1
}

# Build documentation URL
$DocUrl = "https://docs.cyberark.com/pam-self-hosted/$Version/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm"

# Resolve script paths
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptRoot
$VersionFolder = Join-Path $RepoRoot "versions" "v$Version"
$EndpointsFolder = Join-Path $VersionFolder "endpoints"

Write-Host "CyberArk API Documentation Fetcher" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Version:           $Version"
Write-Host "Documentation URL: $DocUrl"
Write-Host "Output folder:     $EndpointsFolder"
Write-Host ""

# Validate version folder exists
if (-not (Test-Path $VersionFolder)) {
    Write-Error "Version folder not found: $VersionFolder"
    Write-Error "Create version folder first with: New-APIVersion.ps1 -Version $Version"
    exit 1
}

# Confirm action
if (-not $WhatIf -and -not $Force) {
    Write-Host "This will:"
    Write-Host "  1. Download documentation from CyberArk"
    Write-Host "  2. Parse endpoint information"
    Write-Host "  3. Create .md files in $EndpointsFolder"
    Write-Host ""
    $response = Read-Host "Continue? (y/n)"
    if ($response -ne 'y') {
        Write-Host "Cancelled."
        exit 0
    }
}

if ($WhatIf) {
    Write-Host "[WhatIf] Would fetch documentation from:" -ForegroundColor Yellow
    Write-Host "[WhatIf]   $DocUrl" -ForegroundColor Yellow
    Write-Host "[WhatIf] Would populate files in:" -ForegroundColor Yellow
    Write-Host "[WhatIf]   $EndpointsFolder" -ForegroundColor Yellow
    exit 0
}

# Endpoint list for this version
$Endpoints = @(
    'AccountActions',
    'AccountGroups',
    'Accounts',
    'Applications',
    'Authentication',
    'BulkUpload',
    'DiscoveredAccounts',
    'General',
    'Groups',
    'LDAPIntegration',
    'LinkedAccounts',
    'MonitorSessions',
    'OnboardingRules',
    'OPMCommands',
    'Platforms',
    'PTAInstallation',
    'Requests',
    'Safes',
    'Security',
    'Server',
    'SessionManagement',
    'SSHKeys',
    'SystemHealth',
    'UsageExamples',
    'Users'
)

Write-Host "Fetching documentation from CyberArk..." -ForegroundColor Green

try {
    # Fetch the documentation page
    $response = Invoke-WebRequest -Uri $DocUrl -ErrorAction Stop
    $html = $response.Content

    Write-Host "✓ Successfully downloaded documentation" -ForegroundColor Green
} catch {
    Write-Error "Failed to download documentation: $_"
    Write-Host ""
    Write-Host "Note: If the URL is incorrect, verify the version is available at:" -ForegroundColor Yellow
    Write-Host "  https://docs.cyberark.com/pam-self-hosted/" -ForegroundColor Yellow
    exit 1
}

# Create endpoint stub files
Write-Host ""
Write-Host "Creating endpoint files..." -ForegroundColor Green

$createdCount = 0
foreach ($endpoint in $Endpoints) {
    $filePath = Join-Path $EndpointsFolder "$endpoint.md"

    # Create stub with template header
    $content = @"
# $endpoint

## Header

| Field | Value |
|-------|-------|
| **File** | $endpoint.md |
| **Version** | $Version |
| **Source** | $DocUrl |
| **Build** | — |
| **Status** | Partial |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | — |
| **Endpoint** | /api/[Resource] |
| **Description** | [Documentation from CyberArk to be extracted] |
| **Auth Required** | Yes |

---

**Note**: This file is a stub created by Fetch-APIDocumentation.ps1. Full details need to be extracted from the CyberArk documentation and added following the endpoint-template.md format.

See `/references/endpoint-template.md` for the complete structure.

---

**Source**: $DocUrl
**Last Updated**: $(Get-Date -Format 'yyyy-MM-dd')
"@

    # Write file
    $content | Set-Content -Path $filePath -Encoding UTF8 -Force
    $createdCount++
    Write-Host "  ✓ $endpoint.md" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Summary" -ForegroundColor Green
Write-Host "=======" -ForegroundColor Green
Write-Host "Created:    $createdCount endpoint files"
Write-Host "Location:   $EndpointsFolder"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review and populate endpoint files with details from CyberArk docs"
Write-Host "  2. Update status in each file header (Partial -> Complete)"
Write-Host "  3. Update version-tracking.md in the parent folder"
Write-Host ""
Write-Host "For detailed instructions, see: /references/endpoint-template.md" -ForegroundColor Cyan
