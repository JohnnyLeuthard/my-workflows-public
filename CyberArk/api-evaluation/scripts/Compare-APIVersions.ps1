<#
.SYNOPSIS
    Diff two populated version folders under versions/ and emit a comparison export.

.DESCRIPTION
    Walks versions/v<From>/endpoints/ and versions/v<To>/endpoints/. Identifies:
      - Added categories (in To, not in From)
      - Removed categories (in From, not in To)
      - Modified categories (in both; overview tables differ)
    Writes exports/comparison_v<From>_to_v<To>_YYYYMMDD.md using
    ../references/version-comparison-template.md.

    Both versions must be populated. If either is still Framework only,
    the script warns and exits.

.PARAMETER From
    Source version (e.g., 12.2 or v12.2).

.PARAMETER To
    Target version (e.g., 14.2.1 or v14.2.1).

.PARAMETER Force
    Overwrite an existing export for today.

.EXAMPLE
    ./Compare-APIVersions.ps1 -From 12.2 -To 14.2.1
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^v?\d+\.\d+(\.\d+)?$')]
    [string]$From,

    [Parameter(Mandatory)]
    [ValidatePattern('^v?\d+\.\d+(\.\d+)?$')]
    [string]$To,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$WorkspaceRoot = Split-Path -Parent $PSScriptRoot
$VersionsRoot = Join-Path $WorkspaceRoot 'versions'
$ExportsFolder = Join-Path $WorkspaceRoot 'exports'

function ConvertTo-VersionParts {
    param([string]$Raw)
    $clean = $Raw.TrimStart('v', 'V')
    [PSCustomObject]@{
        Full       = $clean
        FolderName = "v$clean"
    }
}

function Get-CategoryFiles {
    param([string]$VersionFolder)
    $endpoints = Join-Path $VersionFolder 'endpoints'
    if (-not (Test-Path $endpoints)) { return @() }
    Get-ChildItem -Path $endpoints -Filter '*.md' -File |
        Where-Object { $_.Name -ne 'README.md' }
}

function Get-OverviewRows {
    <# Extract the "| GET | /api/... | desc | Yes |" rows from an endpoint file's Overview table. #>
    param([string]$Path)
    $lines = Get-Content -Path $Path
    $inTable = $false
    $rows = foreach ($line in $lines) {
        if ($line -match '^\s*\|\s*Method\s*\|') { $inTable = $true; continue }
        if ($inTable -and $line -match '^\s*\|\s*-') { continue }
        if ($inTable -and $line -match '^\s*\|') { $line.Trim() }
        elseif ($inTable) { break }
    }
    $rows
}

$FromV = ConvertTo-VersionParts -Raw $From
$ToV   = ConvertTo-VersionParts -Raw $To

$FromFolder = Join-Path $VersionsRoot $FromV.FolderName
$ToFolder   = Join-Path $VersionsRoot $ToV.FolderName

foreach ($f in @($FromFolder, $ToFolder)) {
    if (-not (Test-Path $f)) { throw "Missing version folder: $f" }
}

# Sanity check against version-tracking.md — warn if either side is still Framework only
$tracking = Get-Content (Join-Path $VersionsRoot 'version-tracking.md') -Raw
foreach ($V in @($FromV, $ToV)) {
    if ($tracking -match "^\| $([regex]::Escape($V.Full)) \|.*\| Framework only \|") {
        Write-Warning "v$($V.Full) is marked 'Framework only' in version-tracking.md. Comparison will show empty categories."
    }
}

$fromCats = @(Get-CategoryFiles -VersionFolder $FromFolder | ForEach-Object { $_.BaseName })
$toCats   = @(Get-CategoryFiles -VersionFolder $ToFolder   | ForEach-Object { $_.BaseName })

$added    = $toCats   | Where-Object { $_ -notin $fromCats }
$removed  = $fromCats | Where-Object { $_ -notin $toCats }
$common   = $toCats   | Where-Object { $_ -in    $fromCats }

$modified = foreach ($cat in $common) {
    $fromRows = Get-OverviewRows -Path (Join-Path $FromFolder "endpoints/$cat.md")
    $toRows   = Get-OverviewRows -Path (Join-Path $ToFolder   "endpoints/$cat.md")
    if (($fromRows -join "`n") -ne ($toRows -join "`n")) {
        [PSCustomObject]@{
            Category  = $cat
            FromRows  = $fromRows
            ToRows    = $toRows
        }
    }
}

$today = (Get-Date).ToString('yyyyMMdd')
$exportName = "comparison_v$($FromV.Full)_to_v$($ToV.Full)_$today.md"
$exportPath = Join-Path $ExportsFolder $exportName

if (-not (Test-Path $ExportsFolder)) {
    if ($PSCmdlet.ShouldProcess($ExportsFolder, 'Create directory')) {
        New-Item -ItemType Directory -Path $ExportsFolder -Force | Out-Null
    }
}

if ((Test-Path $exportPath) -and -not $Force) {
    throw "Export already exists: $exportPath. Use -Force to overwrite."
}

$fromUrlMM = ($FromV.Full.Split('.') | Select-Object -First 2) -join '.'
$toUrlMM   = ($ToV.Full.Split('.')   | Select-Object -First 2) -join '.'

$body = @()
$body += "# API Comparison — v$($FromV.Full) → v$($ToV.Full)"
$body += ''
$body += "**Generated:** $((Get-Date).ToString('yyyy-MM-dd'))"
$body += "**From source:** https://docs.cyberark.com/pam-self-hosted/$fromUrlMM/en/content/webservices/"
$body += "**To source:** https://docs.cyberark.com/pam-self-hosted/$toUrlMM/en/content/webservices/"
$body += ''
$body += '## Summary'
$body += ''
$body += '| Metric | Count |'
$body += '|---|---|'
$body += "| Endpoint categories in From | $($fromCats.Count) |"
$body += "| Endpoint categories in To | $($toCats.Count) |"
$body += "| Added categories | $(@($added).Count) |"
$body += "| Removed categories | $(@($removed).Count) |"
$body += "| Modified categories | $(@($modified).Count) |"
$body += ''
$body += '## Added Categories'
$body += ''
if (@($added).Count -eq 0) { $body += '_None._' } else { $added | ForEach-Object { $body += "- ``$_``" } }
$body += ''
$body += '## Removed Categories'
$body += ''
if (@($removed).Count -eq 0) { $body += '_None._' } else { $removed | ForEach-Object { $body += "- ``$_``" } }
$body += ''
$body += '## Modified Categories'
$body += ''
if (@($modified).Count -eq 0) {
    $body += '_None._'
} else {
    foreach ($m in $modified) {
        $body += "### ``$($m.Category)``"
        $body += ''
        $body += '**From overview rows:**'
        $body += '```'
        $body += ($m.FromRows -join "`n")
        $body += '```'
        $body += ''
        $body += '**To overview rows:**'
        $body += '```'
        $body += ($m.ToRows -join "`n")
        $body += '```'
        $body += ''
    }
}
$body += ''
$body += '## Notes'
$body += ''
$body += 'Documentation-only differences (wording, examples, formatting) are excluded — this report only surfaces category-level and overview-table changes. For a human-curated executive summary, author against ``../references/manager-report-template.md`` and save under ``../reports/``.'

$output = $body -join "`n"

if ($PSCmdlet.ShouldProcess($exportPath, 'Write comparison export')) {
    Set-Content -Path $exportPath -Value $output -Encoding UTF8
    Write-Host "Wrote $exportPath" -ForegroundColor Cyan
}
