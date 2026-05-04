<#
.SYNOPSIS
    Fetch live CyberArk PAM API documentation and convert to markdown files.

.PARAMETER Version
    Version string (e.g., 12.2, v14.4.2)

.PARAMETER Force
    Overwrite existing files
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

$WorkspaceRoot = Split-Path -Parent $PSScriptRoot

function ConvertTo-VersionParts {
    param([string]$Raw)
    $clean = $Raw.TrimStart('v', 'V')
    $parts = $clean.Split('.')
    [PSCustomObject]@{
        Full        = $clean
        FolderName  = "v$clean"
        MajorMinor  = "$($parts[0]).$($parts[1])"
    }
}

function Get-DocsUrl {
    param([string]$MajorMinor)
    "https://docs.cyberark.com/pam-self-hosted/$MajorMinor/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm"
}

function Get-KnownEndpoints {
    param([string]$MajorMinor)

    # Hardcoded list of known endpoints per version (discovered from live docs TOC)
    $endpoints = @{
        "12.2" = @(
            @{Name="Authentication"; Path="rest%20web%20services%20api%20-%20authentication.htm"},
            @{Name="System Health"; Path="systemhealth.htm"},
            @{Name="User management"; Path="api-user-mng-lp.htm"},
            @{Name="Safes"; Path="sdk-safe-methods.htm"},
            @{Name="Platforms"; Path="managing%20platforms.htm"},
            @{Name="Accounts"; Path="managing%20accounts.htm"},
            @{Name="Requests"; Path="api-requests-lp.htm"},
            @{Name="Onboarding rules"; Path="onboarding%20rules.htm"},
            @{Name="Monitor sessions"; Path="monitoring.htm"},
            @{Name="Security"; Path="event%20security.htm"},
            @{Name="PTA Installation"; Path="pta%20installation.htm"},
            @{Name="Applications"; Path="applications.htm"},
            @{Name="OPM commands"; Path="api-acl-lp.htm"},
            @{Name="General"; Path="general.htm"},
            @{Name="Usage examples"; Path="usage%20examples.htm"}
        )
    }

    if ($endpoints.ContainsKey($MajorMinor)) {
        $baseUrl = "https://docs.cyberark.com/pam-self-hosted/$MajorMinor/en/content/webservices/"
        return $endpoints[$MajorMinor] | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.Name
                Url = $baseUrl + $_.Path
            }
        }
    }
    return $null
}

function Get-EndpointCategoryLinks {
    param([string]$LandingUrl)

    # Fetch with curl, then parse with Node/jsdom to handle JavaScript-rendered TOC
    $htmlFile = Join-Path $WorkspaceRoot "landing_$([guid]::NewGuid().ToString()).html"

    try {
        & curl -s -L -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" $LandingUrl -o $htmlFile 2>$null

        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $htmlFile)) {
            Write-Host "Failed to fetch landing page with curl" -ForegroundColor Red
            return
        }

        $nodeScript = @"
const fs = require('fs');
const { JSDOM } = require('jsdom');

const html = fs.readFileSync('$htmlFile', 'utf8');
const dom = new JSDOM(html);
const { document } = dom.window;

const links = Array.from(document.querySelectorAll('a'))
  .map(a => ({ href: a.getAttribute('href'), text: a.textContent.trim() }))
  .filter(l => l.href && l.href.includes('/webservices/') && l.href.includes('.htm') && !l.href.includes('implementing'))
  .filter((v, i, a) => a.findIndex(x => x.href === v.href) === i);

console.log(JSON.stringify(links));
"@

        $tempScript = Join-Path $WorkspaceRoot "parse_toc_$([guid]::NewGuid().ToString()).js"
        Set-Content -Path $tempScript -Value $nodeScript -Encoding UTF8

        try {
            $output = & node $tempScript 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Error parsing TOC" -ForegroundColor Yellow
                return
            }

            $json = $output | Select-Object -Last 1
            if (-not $json) { return }

            $links = $json | ConvertFrom-Json

            $base = [Uri]$LandingUrl
            foreach ($link in $links) {
                $absolute = if ($link.href -match '^https?://') {
                    $link.href
                } else {
                    (New-Object Uri($base, $link.href)).AbsoluteUri
                }

                [PSCustomObject]@{ Name = $link.text; Url = $absolute }
            }
        } finally {
            Remove-Item -Path $tempScript -Force -ErrorAction SilentlyContinue
        }
    } finally {
        Remove-Item -Path $htmlFile -Force -ErrorAction SilentlyContinue
    }
}

function Fetch-EndpointPageAndConvert {
    param([string]$Url, [string]$Title)

    # Fetch HTML with curl and convert to markdown directly
    $nodeScript = @"
const https = require('https');
const { convert } = require('html-to-text');

let html = '';
const u = new URL('$Url');
const options = {
  hostname: u.hostname,
  path: u.pathname + u.search,
  headers: {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  }
};

https.get(options, (res) => {
  res.on('data', chunk => html += chunk);
  res.on('end', () => {
    try {
      const text = convert(html, {
        wordwrap: 100,
        baseUrl: '$Url',
        preserveNewlines: true,
        ignoreHref: true
      });
      console.log(text);
    } catch(e) {
      console.error('Convert error: ' + e.message);
      process.exit(1);
    }
  });
}).on('error', (e) => {
  console.error('Fetch error: ' + e.message);
  process.exit(1);
});
"@

    $tempScript = Join-Path $WorkspaceRoot "fetch_convert_$([guid]::NewGuid().ToString()).js"
    Set-Content -Path $tempScript -Value $nodeScript -Encoding UTF8

    try {
        $content = & node $tempScript 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: $(($content | Select-Object -Last 2) -join ' ')" -ForegroundColor Gray
            return $null
        }
        return $content -join "`n"
    } finally {
        Remove-Item -Path $tempScript -Force -ErrorAction SilentlyContinue
    }
}

# Main
$V = ConvertTo-VersionParts -Raw $Version
$VersionsRoot = Join-Path $WorkspaceRoot 'versions'
$VersionFolder = Join-Path $VersionsRoot $V.FolderName
$EndpointsFolder = Join-Path $VersionFolder 'endpoints'
$LandingUrl = Get-DocsUrl -MajorMinor $V.MajorMinor

if (-not (Test-Path $VersionFolder)) {
    throw "Version folder not found: $VersionFolder. Run New-APIVersion.ps1 first."
}

if (-not (Test-Path $EndpointsFolder)) {
    New-Item -ItemType Directory -Path $EndpointsFolder -Force | Out-Null
}

Write-Host "Landing page: $LandingUrl" -ForegroundColor Cyan
Write-Host "Target folder: $EndpointsFolder" -ForegroundColor Cyan

if (-not $PSCmdlet.ShouldProcess($LandingUrl, 'Fetch endpoint list and pages')) {
    Write-Host "[WhatIf] Would fetch all endpoint pages" -ForegroundColor Yellow
    return
}

# Try known endpoints first, then fall back to dynamic
$categories = @(Get-KnownEndpoints -MajorMinor $V.MajorMinor)

if ($categories.Length -eq 0) {
    Write-Host "Using dynamic endpoint discovery..." -ForegroundColor Gray
    $categories = @(Get-EndpointCategoryLinks -LandingUrl $LandingUrl)
}

Write-Host "Found $($categories.Length) endpoint categories" -ForegroundColor Cyan

$written = 0
$failed = 0

foreach ($cat in $categories) {
    $safeName = ($cat.Name -replace '[^\w\-]', '')
    if (-not $safeName) { continue }

    $outPath = Join-Path $EndpointsFolder "$safeName.md"

    if ((Test-Path $outPath) -and -not $Force) {
        Write-Host "Skipping (exists): $safeName" -ForegroundColor Gray
        continue
    }

    if (-not $PSCmdlet.ShouldProcess($outPath, "Download $($cat.Name)")) {
        continue
    }

    Write-Host "Downloading: $($cat.Name)" -ForegroundColor Cyan
    $pageContent = Fetch-EndpointPageAndConvert -Url $cat.Url -Title $cat.Name

    if (-not $pageContent) {
        $failed++
        continue
    }

    $markdown = @"
---
filename: $safeName.md
version: $($V.Full)
source_url: $($cat.Url)
build: unknown
status: Populated
---

# $($cat.Name)

_Downloaded: $(Get-Date -Format 'yyyy-MM-dd')_
_Source: [CyberArk Docs]($($cat.Url))_

---

$pageContent
"@

    Set-Content -Path $outPath -Value $markdown -Encoding UTF8
    $written++
    Start-Sleep -Milliseconds 500  # Rate limiting
}

Write-Host "Downloaded: $written files | Failed: $failed" -ForegroundColor Cyan
