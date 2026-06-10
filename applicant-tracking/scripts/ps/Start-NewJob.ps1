<#
.SYNOPSIS
    Scaffold a new job folder in 03-jobs/.

.DESCRIPTION
    PowerShell equivalent of new_job.py. Creates the job folder structure
    with stub files. No AI involved — AI fills in content afterward.

.PARAMETER Title
    Job title, e.g. "Senior DevOps Engineer"

.PARAMETER Type
    FTE or Contractor

.PARAMETER Year
    Year the job opened (default: current year)

.PARAMETER Month
    Month the job opened (default: current month)

.PARAMETER WhatIf
    Dry run — show what would be created without creating it.

.EXAMPLE
    .\Start-NewJob.ps1 -Title "Senior DevOps Engineer" -Type FTE
    .\Start-NewJob.ps1 -Title "QA Engineer" -Type Contractor -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [string] $Title,
    [Parameter(Mandatory)] [ValidateSet("FTE","Contractor")] [string] $Type,
    [int] $Year  = (Get-Date).Year,
    [int] $Month = (Get-Date).Month
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot   = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Split-Path -Parent $ScriptRoot
$JobsDir       = Join-Path $WorkspaceRoot "03-jobs"

function ConvertTo-PascalCase([string]$Text) {
    ($Text -split '\s+' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''
}

$Slug    = ConvertTo-PascalCase $Title
$JobKey  = "{0:D4}-{1:D2}-{2}-{3}" -f $Year, $Month, $Slug, $Type
$JobDir  = Join-Path $JobsDir $JobKey

# Handle collisions
$Suffix = 2
while (Test-Path $JobDir) {
    $JobKey = "{0:D4}-{1:D2}-{2}-{3}-{4}" -f $Year, $Month, $Slug, $Type, $Suffix
    $JobDir = Join-Path $JobsDir $JobKey
    $Suffix++
}

Write-Host "`nJob Key: $JobKey"

$Today = (Get-Date -Format "yyyy-MM-dd")

$ScoringHeader = "# Scoring — $JobKey`n`n| Candidate ID | Candidate Name | Date Applied | Core Skills (1–5) | Experience (1–5) | Education (1–5) | Track Record (1–5) | Weighted Score | Recommendation | Status |`n|---|---|---|---|---|---|---|---|---|---|`n"

$Files = @{
    "job-description.md"    = "# $JobKey`n`n<!-- AI: fill in from job description -->`n"
    "skills-matrix.md"      = "# Skills Matrix — $JobKey`n`n<!-- AI: fill in required and nice-to-have skills tables -->`n"
    "screening-questions.md"= "# Screening Questions — $JobKey`n`n<!-- AI: generate 5 behavioral + 3 technical questions from job description -->`n"
    "scoring.md"            = $ScoringHeader
    "metadata.json"         = @{
        jobKey                = $JobKey
        jobTitle              = "<!-- AI: fill in -->"
        type                  = $Type
        dateOpened            = $Today
        department            = $null
        hiringManager         = $null
        requiredSkills        = @()
        niceToHaveSkills      = @()
        yearsRequired         = 0
        educationRequired     = $null
        certificationsRequired= @()
        complianceRequired    = $false
        status                = "open"
    } | ConvertTo-Json -Depth 5
}

if ($PSCmdlet.ShouldProcess($JobDir, "Create job folder")) {
    New-Item -ItemType Directory -Path $JobDir | Out-Null
    Write-Host "Created folder: $JobDir"
    foreach ($File in $Files.GetEnumerator()) {
        $FilePath = Join-Path $JobDir $File.Key
        Set-Content -Path $FilePath -Value $File.Value -Encoding UTF8
        Write-Host "  Created: $($File.Key)"
    }
} else {
    Write-Host "[WhatIf] Would create: $JobDir"
    foreach ($File in $Files.Keys) {
        Write-Host "  [WhatIf] $File"
    }
}

Write-Host @"

Next step — ask your AI:
  "Job folder $JobKey is ready. Here is the job description:
   <paste job description text here>
   Please populate job-description.md, metadata.json, skills-matrix.md,
   and screening-questions.md in 03-jobs/$JobKey/"
"@
