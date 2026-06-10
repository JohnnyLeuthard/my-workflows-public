<#
.SYNOPSIS
    Archive a completed, cancelled, or on-hold job position.

.DESCRIPTION
    PowerShell equivalent of archive_job.py. Moves job folder, candidate
    folders, and interview log to 07-archive/, then creates a status.md stub.

.PARAMETER JobKey
    Job Key to archive, e.g. "2026-06-SeniorDevOpsEngineer-FTE"

.PARAMETER Reason
    Reason for closing: filled, cancelled, on-hold, or withdrawn

.PARAMETER Force
    Archive even if some candidates have non-final status

.PARAMETER WhatIf
    Dry run.

.EXAMPLE
    .\Archive-Job.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" -Reason filled
    .\Archive-Job.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" -Reason cancelled -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [string] $JobKey,
    [Parameter(Mandatory)] [ValidateSet("filled","cancelled","on-hold","withdrawn")] [string] $Reason,
    [switch] $Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot    = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Split-Path -Parent $ScriptRoot
$JobSrc        = Join-Path $WorkspaceRoot "03-jobs\$JobKey"
$ArchiveDir    = Join-Path $WorkspaceRoot "07-archive"
$ArchiveJobDir = Join-Path $ArchiveDir $JobKey
$InterviewSrc  = Join-Path $WorkspaceRoot "06-interviews\$JobKey-interviews.md"
$ApplicantsDir = Join-Path $WorkspaceRoot "04-applicants"
$Today         = (Get-Date -Format "yyyy-MM-dd")

$FinalStatuses = @("accepted","rejected","withdrawn")

if (-not (Test-Path $JobSrc)) { Write-Error "Job folder not found: $JobSrc"; exit 1 }
if (Test-Path $ArchiveJobDir) { Write-Error "Archive folder already exists: $ArchiveJobDir"; exit 1 }

Write-Host "`nArchiving: $JobKey"
Write-Host "Reason: $Reason`n"

# Load job metadata
$JobMeta = @{ jobTitle = "Unknown"; type = "Unknown"; dateOpened = "Unknown" }
$MetaPath = Join-Path $JobSrc "metadata.json"
if (Test-Path $MetaPath) { $JobMeta = Get-Content $MetaPath -Raw | ConvertFrom-Json }

# Find candidate IDs from scoring.md
$CandidateIds = @()
$ScoringPath = Join-Path $JobSrc "scoring.md"
if (Test-Path $ScoringPath) {
    $ScoringText = Get-Content $ScoringPath -Raw
    $CandidateIds = [regex]::Matches($ScoringText, '\b([A-Za-z]+-[A-Za-z]+-\d{4}-\d{2}-\d{2})\b') |
        Select-Object -ExpandProperty Value | Select-Object -Unique
}

# Check candidate statuses
if (-not $Force) {
    $Unfinished = foreach ($Cid in $CandidateIds) {
        $CidMeta = Join-Path $ApplicantsDir "$Cid\metadata.json"
        if (Test-Path $CidMeta) {
            $M = Get-Content $CidMeta -Raw | ConvertFrom-Json
            if ($M.screeningStatus -notin $FinalStatuses) { "$Cid ($($M.screeningStatus))" }
        }
    }
    if ($Unfinished) {
        Write-Warning "Some candidates have non-final status:"
        $Unfinished | ForEach-Object { Write-Host "  $_" }
        Write-Host "Update status or use -Force to archive anyway."
        exit 1
    }
}

# Create archive structure
if ($PSCmdlet.ShouldProcess($ArchiveJobDir, "Create archive folder")) {
    New-Item -ItemType Directory -Path $ArchiveJobDir | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $ArchiveJobDir "applicants") | Out-Null
}

# Move job folder contents
if ($PSCmdlet.ShouldProcess($JobSrc, "Move job folder contents")) {
    Get-ChildItem -Path $JobSrc | Move-Item -Destination $ArchiveJobDir
    Remove-Item -Path $JobSrc
    Write-Host "  Moved job folder contents to $ArchiveJobDir"
}

# Move candidate folders
foreach ($Cid in $CandidateIds) {
    $CandSrc = Join-Path $ApplicantsDir $Cid
    if (Test-Path $CandSrc) {
        if ($PSCmdlet.ShouldProcess($CandSrc, "Move candidate folder")) {
            Move-Item -Path $CandSrc -Destination (Join-Path $ArchiveJobDir "applicants\$Cid")
            Write-Host "  Moved candidate: $Cid"
        }
    }
}

# Move interview log
if (Test-Path $InterviewSrc) {
    if ($PSCmdlet.ShouldProcess($InterviewSrc, "Move interview log")) {
        Move-Item -Path $InterviewSrc -Destination (Join-Path $ArchiveJobDir (Split-Path -Leaf $InterviewSrc))
        Write-Host "  Moved interview log"
    }
}

# Create status.md stub
$StatusContent = @"
# Archive Status — $JobKey

**Job Title**: $($JobMeta.jobTitle)
**Job Type**: $($JobMeta.type)
**Date Opened**: $($JobMeta.dateOpened)
**Date Closed**: $Today
**Close Reason**: $($Reason.Substring(0,1).ToUpper() + $Reason.Substring(1))

## Outcome

- **Total Applicants**: <!-- fill in -->
- **Interviewed**: <!-- fill in -->
- **Offer Extended To**: <!-- CandidateID or None -->
- **Offer Accepted By**: <!-- CandidateID or None -->
- **Start Date**: <!-- YYYY-MM-DD or N/A -->

## Notes

<!-- AI: summarize outcomes, lessons learned, notes for future similar openings -->
"@

$StatusPath = Join-Path $ArchiveJobDir "status.md"
if ($PSCmdlet.ShouldProcess($StatusPath, "Create status.md")) {
    Set-Content -Path $StatusPath -Value $StatusContent -Encoding UTF8
    Write-Host "  Created: $StatusPath"
}

Write-Host @"

Archive complete.

Next step — ask your AI:
  "The job $JobKey has been archived (reason: $Reason).
   Please fill in 07-archive/$JobKey/status.md with a summary of the hiring outcomes."
"@
