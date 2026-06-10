<#
.SYNOPSIS
    Add an interview entry to the job interview log and update candidate status.

.DESCRIPTION
    PowerShell equivalent of new_interview.py. Creates or appends to the
    interview log and candidate interview.md. No AI involved.

.PARAMETER JobKey
    Job Key, e.g. "2026-06-SeniorDevOpsEngineer-FTE"

.PARAMETER CandidateId
    Candidate ID, e.g. "Smith-Jane-2026-06-01"

.PARAMETER Round
    Interview round name, e.g. "Phone Screen", "Round 1", "Technical Deep Dive"

.PARAMETER Interviewer
    Interviewer name(s), e.g. "Jordan Ellis" or "Jordan Ellis, Sam Park"

.PARAMETER InterviewDate
    Date of interview in YYYY-MM-DD format (default: today)

.PARAMETER WhatIf
    Dry run.

.EXAMPLE
    .\Start-NewInterview.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" `
        -CandidateId "Smith-Jane-2026-06-01" -Round "Phone Screen" `
        -Interviewer "Jordan Ellis" -InterviewDate "2026-06-05"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [string] $JobKey,
    [Parameter(Mandatory)] [string] $CandidateId,
    [Parameter(Mandatory)] [string] $Round,
    [Parameter(Mandatory)] [string] $Interviewer,
    [string] $InterviewDate = (Get-Date -Format "yyyy-MM-dd")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot    = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Split-Path -Parent $ScriptRoot
$CandidateDir  = Join-Path $WorkspaceRoot "04-applicants\$CandidateId"
$InterviewsDir = Join-Path $WorkspaceRoot "06-interviews"
$LogPath       = Join-Path $InterviewsDir "$JobKey-interviews.md"
$MetaPath      = Join-Path $CandidateDir "metadata.json"
$InterviewMd   = Join-Path $CandidateDir "interview.md"

if (-not (Test-Path $CandidateDir)) {
    Write-Error "Candidate folder not found: $CandidateDir"
    exit 1
}

$CandidateName = $CandidateId
if (Test-Path $MetaPath) {
    $Meta = Get-Content $MetaPath -Raw | ConvertFrom-Json
    if ($Meta.candidateName -and $Meta.candidateName -ne "<!-- AI: fill in -->") {
        $CandidateName = $Meta.candidateName
    }
}

Write-Host "`nJob: $JobKey"
Write-Host "Candidate: $CandidateId ($CandidateName)"
Write-Host "Round: $Round | Date: $InterviewDate | Interviewer: $Interviewer`n"

# Ensure interview log exists
if (-not (Test-Path $LogPath)) {
    $LogHeader = @"
# Interview Log — $JobKey

| Candidate ID | Candidate Name | Round | Date | Interviewer(s) | Status | Recommendation | Notes |
|---|---|---|---|---|---|---|---|
"@
    if ($PSCmdlet.ShouldProcess($LogPath, "Create interview log")) {
        if (-not (Test-Path $InterviewsDir)) { New-Item -ItemType Directory -Path $InterviewsDir | Out-Null }
        Set-Content -Path $LogPath -Value $LogHeader -Encoding UTF8
        Write-Host "  Created interview log: $LogPath"
    }
}

# Append interview row
$Row = "| $CandidateId | $CandidateName | $Round | $InterviewDate | $Interviewer | Scheduled | — | |"
if ($PSCmdlet.ShouldProcess($LogPath, "Append interview row")) {
    Add-Content -Path $LogPath -Value $Row -Encoding UTF8
    Write-Host "  Appended interview row: $CandidateId / $Round"
}

# Create or append to interview.md
$Section = @"

## $Round

**Date**: $InterviewDate
**Interviewer(s)**: $Interviewer
**Duration**: <!-- fill in -->
**Format**: <!-- Phone / Video / On-site -->
**Status**: Scheduled

### Questions

| Question ID | Category | Question | Asked | Response Summary | Rating (1–5) | Follow-up Needed | Notes |
|------------|----------|----------|-------|-----------------|--------------|-----------------|-------|
| <!-- Q-001 --> | <!-- Category --> | <!-- Question --> | — | — | — | — | |

### Overall Round Assessment

**Strengths Observed**: <!-- fill in -->
**Concerns Raised**: <!-- fill in -->
**Round Recommendation**: <!-- Advance / Hold / Decline -->
**Interviewer Notes**: <!-- fill in -->
"@

if (-not (Test-Path $InterviewMd)) {
    $Header = "# Interview Record — $CandidateId`n`n**Job**: $JobKey`n"
    if ($PSCmdlet.ShouldProcess($InterviewMd, "Create interview.md")) {
        Set-Content -Path $InterviewMd -Value ($Header + $Section) -Encoding UTF8
        Write-Host "  Created: $InterviewMd"
    }
} else {
    if ($PSCmdlet.ShouldProcess($InterviewMd, "Append Round section")) {
        Add-Content -Path $InterviewMd -Value $Section -Encoding UTF8
        Write-Host "  Appended Round section to: $InterviewMd"
    }
}

# Update metadata
if ((Test-Path $MetaPath) -and $PSCmdlet.ShouldProcess($MetaPath, "Update metadata")) {
    $Meta = Get-Content $MetaPath -Raw | ConvertFrom-Json
    $Meta.screeningStatus    = "interview"
    $Meta.interviewScheduled = $true
    if (-not $Meta.interviewDate) { $Meta.interviewDate = $InterviewDate }
    $Meta | ConvertTo-Json -Depth 5 | Set-Content -Path $MetaPath -Encoding UTF8
    Write-Host "  Updated metadata.json: status=interview, interviewDate=$InterviewDate"
}

Write-Host @"

Next step — ask your AI:
  "Interview $Round for $CandidateId is scheduled on $InterviewDate.
   Please copy the relevant questions from 03-jobs/$JobKey/screening-questions.md
   into the new round section of 04-applicants/$CandidateId/interview.md."
"@
