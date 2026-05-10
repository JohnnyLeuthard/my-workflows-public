<#
.SYNOPSIS
Compares two CyberArk API versions and generates a detailed comparison report.

.DESCRIPTION
Analyzes endpoint files from two versions and generates a comparison report highlighting:
- New endpoints
- Modified endpoints
- Deprecated/removed endpoints
- Breaking changes
- Migration recommendations

Output is formatted as a markdown file following version-comparison-template.md.

.PARAMETER From
Source version to compare from (e.g., '12.2').

.PARAMETER To
Target version to compare to (e.g., '14.2').

.PARAMETER Platform
Platform for both From and To versions: 'SH' (Self-Hosted, default) or 'PC' (Privilege Cloud).
Used when comparing same-platform versions (most common case).

.PARAMETER FromPlatform
Optional override: Platform for From version (SH or PC).
Use when comparing across platforms (e.g., SH v14.2 vs PC v14.2).

.PARAMETER ToPlatform
Optional override: Platform for To version (SH or PC).
Use when comparing across platforms.

.PARAMETER WhatIf
Preview what would be compared without creating the report.

.PARAMETER Force
Skip confirmation prompts and proceed with comparison.

.EXAMPLE
.\Compare-APIVersions.ps1 -From 12.2 -To 14.2

Compares Self-Hosted v12.2 → v14.2 and generates exports/comparison_sh-v12.2_to_sh-v14.2_YYYYMMDD.md

.EXAMPLE
.\Compare-APIVersions.ps1 -From 14.2 -To 14.2 -FromPlatform SH -ToPlatform PC

Compares Self-Hosted v14.2 → Privilege Cloud v14.2 (cross-platform).

.EXAMPLE
.\Compare-APIVersions.ps1 -From 14.2 -To 24.1 -Platform PC -Force

Compares Privilege Cloud v14.2 → v24.1 without confirmation.

.NOTES
- Generates comprehensive comparison report in exports/ folder
- Report includes breaking change analysis and migration recommendations
- Timestamp included in filename for version tracking
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$From,

    [Parameter(Mandatory = $true)]
    [string]$To,

    [ValidateSet('SH', 'PC')]
    [string]$Platform = 'SH',

    [ValidateSet('SH', 'PC')]
    [string]$FromPlatform,

    [ValidateSet('SH', 'PC')]
    [string]$ToPlatform,

    [switch]$WhatIf,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# Normalize versions
$From = $From -replace '^v', ''
$To = $To -replace '^v', ''

# Validate version formats
if ($From -notmatch '^\d+\.\d+(\.\d+)?$' -or $To -notmatch '^\d+\.\d+(\.\d+)?$') {
    Write-Error "Invalid version format. Use X.X or X.X.X"
    exit 1
}

# Resolve platforms (use overrides if provided, otherwise use $Platform)
$FromPlatformResolved = if ($FromPlatform) { $FromPlatform } else { $Platform }
$ToPlatformResolved = if ($ToPlatform) { $ToPlatform } else { $Platform }

# Resolve platform folder names
$FromPlatformFolder = if ($FromPlatformResolved -eq 'PC') { 'privilege-cloud' } else { 'self-hosted' }
$ToPlatformFolder = if ($ToPlatformResolved -eq 'PC') { 'privilege-cloud' } else { 'self-hosted' }

# Resolve script paths
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptRoot
$FromFolder = Join-Path $RepoRoot "versions" $FromPlatformFolder "v$From"
$ToFolder = Join-Path $RepoRoot "versions" $ToPlatformFolder "v$To"
$ExportsFolder = Join-Path $RepoRoot "exports"

# Ensure exports folder exists
if (-not (Test-Path $ExportsFolder)) {
    New-Item -ItemType Directory -Path $ExportsFolder | Out-Null
}

# Build report filename with platform tags
$FromTag = $FromPlatformResolved.ToLower()
$ToTag = $ToPlatformResolved.ToLower()
$timestamp = Get-Date -Format "yyyyMMdd"
$reportFile = Join-Path $ExportsFolder "comparison_${FromTag}-v${From}_to_${ToTag}-v${To}_${timestamp}.md"

Write-Host "CyberArk API Version Comparison" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "From Version:   $FromTag-v$From"
Write-Host "To Version:     $ToTag-v$To"
Write-Host "Report File:    $reportFile"
Write-Host ""

# Validate version folders exist
if (-not (Test-Path $FromFolder)) {
    Write-Error "Version folder not found: $FromFolder"
    exit 1
}

if (-not (Test-Path $ToFolder)) {
    Write-Error "Version folder not found: $ToFolder"
    exit 1
}

# Confirm action
if (-not $WhatIf -and -not $Force) {
    Write-Host "This will:"
    Write-Host "  1. Compare endpoints in $FromTag-v$From and $ToTag-v$To"
    Write-Host "  2. Identify new, modified, and removed endpoints"
    Write-Host "  3. Generate comparison report in exports/"
    Write-Host ""
    $response = Read-Host "Continue? (y/n)"
    if ($response -ne 'y') {
        Write-Host "Cancelled."
        exit 0
    }
}

if ($WhatIf) {
    Write-Host "[WhatIf] Would compare $FromTag-v$From to $ToTag-v$To" -ForegroundColor Yellow
    Write-Host "[WhatIf] Would generate report:" -ForegroundColor Yellow
    Write-Host "[WhatIf]   $reportFile" -ForegroundColor Yellow
    exit 0
}

Write-Host "Analyzing endpoints..." -ForegroundColor Green

# Get endpoint files from both versions
$FromEndpoints = @(Get-ChildItem -Path (Join-Path $FromFolder "endpoints") -Filter "*.md" -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "README.md" } | Select-Object -ExpandProperty BaseName)
$ToEndpoints = @(Get-ChildItem -Path (Join-Path $ToFolder "endpoints") -Filter "*.md" -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "README.md" } | Select-Object -ExpandProperty BaseName)

# Analyze differences
$addedEndpoints = @($ToEndpoints | Where-Object { $_ -notin $FromEndpoints })
$removedEndpoints = @($FromEndpoints | Where-Object { $_ -notin $ToEndpoints })
$commonEndpoints = @($FromEndpoints | Where-Object { $_ -in $ToEndpoints })

Write-Host "✓ Analysis complete" -ForegroundColor Green
Write-Host "  From $FromTag-v$From : $($FromEndpoints.Count) endpoints"
Write-Host "  To $ToTag-v$To       : $($ToEndpoints.Count) endpoints"
Write-Host "  Added:             $($addedEndpoints.Count)"
Write-Host "  Removed:           $($removedEndpoints.Count)"
Write-Host "  Modified (review): [manual inspection required]"
Write-Host ""

# Build report content
$FromLabel = if ($FromPlatformResolved -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' }
$ToLabel = if ($ToPlatformResolved -eq 'PC') { 'Privilege Cloud' } else { 'Self-Hosted' }

$reportContent = @"
# Version Comparison Report

**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**From**: $FromLabel v$From
**To**: $ToLabel v$To
**Report Type**: Technical Comparison (Raw Data)

---

## Executive Summary

| Metric | Value |
|--------|-------|
| **Total Endpoints (From)** | $($FromEndpoints.Count) |
| **Total Endpoints (To)** | $($ToEndpoints.Count) |
| **New Endpoints** | $($addedEndpoints.Count) |
| **Removed Endpoints** | $($removedEndpoints.Count) |
| **Potentially Modified** | $($commonEndpoints.Count) |
| **Breaking Changes** | [Manual review required] |
| **Migration Complexity** | [To be assessed] |

---

## Changes by Category

### Added Endpoints (New in $ToLabel v$To)

$($addedEndpoints | ForEach-Object { "- $_" } | Out-String)
**Count**: $($addedEndpoints.Count)

For details on each new endpoint, see:
- ``versions/$ToPlatformFolder/v$To/endpoints/`` folder
- ``versions/$ToPlatformFolder/v$To/changelog.md``

---

### Removed Endpoints (No longer in $ToLabel v$To)

$($removedEndpoints | ForEach-Object { "- $_" } | Out-String)
**Count**: $($removedEndpoints.Count)

**Action required**: Check if your implementations use any of these endpoints. Migration path may be needed.

---

### Potentially Modified Endpoints

$($commonEndpoints | ForEach-Object { "- $_" } | Out-String)
**Count**: $($commonEndpoints.Count)

**Note**: These endpoints exist in both versions. Manual review of $FromLabel v$From vs $ToLabel v$To endpoint files is required to identify:
- Parameter changes
- Response schema changes
- Authentication requirement changes
- Behavioral changes

---

## Breaking Changes Analysis

(Requires manual review of endpoint files)

**To identify breaking changes**:
1. Open each endpoint file in \`versions/$FromPlatformFolder/v$From/endpoints/\`
2. Compare with corresponding file in \`versions/$ToPlatformFolder/v$To/endpoints/\`
3. Look for changes in:
   - Required parameters
   - Response schema
   - HTTP methods
   - Authentication requirements
   - Behavioral notes

---

## Migration Checklist

### Pre-Upgrade

- [ ] Review all changes above
- [ ] Audit current API client code for affected endpoints
- [ ] Test against $ToLabel v$To in non-prod environment
- [ ] Plan rollback strategy

### Upgrade Execution

- [ ] Verify all custom scripts still function
- [ ] Test new endpoints (if using them)
- [ ] Monitor API error rates and audit logs

### Post-Upgrade

- [ ] Re-test all automated workflows
- [ ] Update API documentation
- [ ] Verify deprecated endpoints removed from codebase

---

## Summary

**Overall Migration Complexity**: [Low / Medium / High] — requires manual assessment

**Recommended Action**: [Assess each change in the following categories]

### For New Endpoints ($($addedEndpoints.Count) new)

Can you leverage these new capabilities? If yes, plan testing and implementation.

### For Removed Endpoints ($($removedEndpoints.Count) removed)

Do any of your integrations use these? If yes, plan migration to alternatives or stay on $FromLabel v$From.

### For Potentially Modified Endpoints ($($commonEndpoints.Count) common)

Are there breaking changes? Manual review required.

---

## Appendix: File Listings

### All endpoints in $FromLabel v$From
\`\`\`
$($FromEndpoints -join "`n")
\`\`\`

### All endpoints in $ToLabel v$To
\`\`\`
$($ToEndpoints -join "`n")
\`\`\`

---

**Report Generated By**: Compare-APIVersions.ps1
**Source Data**: Endpoint .md files in versions/$FromPlatformFolder/v$From/ and versions/$ToPlatformFolder/v$To/ folders
**Last Updated**: $(Get-Date -Format 'yyyy-MM-dd')
"@

# Write report
$reportContent | Set-Content -Path $reportFile -Encoding UTF8
Write-Host "✓ Report generated" -ForegroundColor Green
Write-Host ""
Write-Host "Summary" -ForegroundColor Green
Write-Host "=======" -ForegroundColor Green
Write-Host "Report:           $(Split-Path -Leaf $reportFile)"
Write-Host "Added endpoints:  $($addedEndpoints.Count)"
Write-Host "Removed:          $($removedEndpoints.Count)"
Write-Host "Common:           $($commonEndpoints.Count)"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review the raw comparison report in exports/"
Write-Host "  2. Create a manager report: copy references/manager-report-template.md"
Write-Host "  3. Create a developer report: copy references/developer-report-template.md"
Write-Host "  4. Manually compare endpoint files for detailed changes"
