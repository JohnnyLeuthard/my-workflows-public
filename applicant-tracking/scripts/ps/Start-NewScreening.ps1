<#
.SYNOPSIS
    Scan resume inbox and scaffold candidate folders in 04-applicants/.

.DESCRIPTION
    PowerShell equivalent of new_screening.py. Validates resume filenames,
    creates candidate folder stubs. No AI involved.

.PARAMETER JobKey
    Job Key to link candidates to, e.g. "2026-06-SeniorDevOpsEngineer-FTE"

.PARAMETER Force
    Overwrite existing candidate folders.

.PARAMETER WhatIf
    Dry run — show what would be created without creating it.

.EXAMPLE
    .\Start-NewScreening.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE"
    .\Start-NewScreening.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [string] $JobKey,
    [switch] $Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot    = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Split-Path -Parent $ScriptRoot
$Inbox         = Join-Path $WorkspaceRoot "02-resume-intake\_inbox"
$ApplicantsDir = Join-Path $WorkspaceRoot "04-applicants"
$JobsDir       = Join-Path $WorkspaceRoot "03-jobs"
$Today         = (Get-Date -Format "yyyy-MM-dd")

if (-not (Test-Path (Join-Path $JobsDir $JobKey))) {
    Write-Error "Job folder not found: $JobKey"
    exit 1
}

$PDFs = Get-ChildItem -Path $Inbox -Filter "*.pdf" -ErrorAction SilentlyContinue
if (-not $PDFs) {
    Write-Warning "No PDF files found in $Inbox"
    Write-Host "Drop resumes named LastName-Firstname-YYYY-MM-DD.pdf into 02-resume-intake/_inbox/ and re-run."
    exit 0
}

$Pattern   = '^([A-Za-z]+)-([A-Za-z]+)-(\d{4}-\d{2}-\d{2})\.pdf$'
$Created   = [System.Collections.Generic.List[string]]::new()
$Skipped   = [System.Collections.Generic.List[string]]::new()
$Invalid   = [System.Collections.Generic.List[string]]::new()

Write-Host "`nScanning $Inbox"
Write-Host "Job: $JobKey`n"

foreach ($PDF in $PDFs) {
    if ($PDF.Name -notmatch $Pattern) {
        Write-Warning "SKIP (invalid name): $($PDF.Name) — expected LastName-Firstname-YYYY-MM-DD.pdf"
        $Invalid.Add($PDF.Name)
        continue
    }
    $CandidateId = $PDF.BaseName  # filename without .pdf IS the CandidateID
    $CandidateDir = Join-Path $ApplicantsDir $CandidateId

    if ((Test-Path $CandidateDir) -and -not $Force) {
        Write-Host "  SKIP (exists): $CandidateId — use -Force to overwrite"
        $Skipped.Add($CandidateId)
        continue
    }

    $Metadata = @{
        candidateId       = $CandidateId
        candidateName     = "<!-- AI: fill in -->"
        phone             = $null
        email             = $null
        location          = $null
        citizenship       = $null
        dateAdded         = $Today
        appliedJobKey     = $JobKey
        screeningStatus   = "resume_received"
        analysisCompleted = $false
        interviewScheduled= $null
        interviewDate     = $null
        overallScore      = $null
        recommendation    = $null
        offerExtended     = $false
        offerAccepted     = $null
        startDate         = $null
    } | ConvertTo-Json -Depth 5

    $ScoringStub = @"
# Scoring — $CandidateId

**Job Applied For**: $JobKey
**Date Applied**: $Today
**Scored On**: Pending

| Category | Raw Score (1–5) | Weight | Weighted Score |
|----------|----------------|--------|---------------|
| Core Skills | — | 40% | — |
| Experience | — | 30% | — |
| Education / Certs | — | 15% | — |
| Track Record | — | 15% | — |
| **TOTAL** | | | **—** |

**Recommendation**: Pending
**Notes**:
"@

    if ($PSCmdlet.ShouldProcess($CandidateDir, "Create candidate folder")) {
        New-Item -ItemType Directory -Path $CandidateDir -Force:$Force | Out-Null
        Set-Content -Path (Join-Path $CandidateDir "metadata.json") -Value $Metadata -Encoding UTF8
        Set-Content -Path (Join-Path $CandidateDir "analysis.md") -Value "# Analysis — $CandidateId`n`n<!-- AI: fill in from resume content -->`n" -Encoding UTF8
        Set-Content -Path (Join-Path $CandidateDir "scoring.md") -Value $ScoringStub -Encoding UTF8
        Write-Host "  Created: $CandidateDir"
        $Created.Add($CandidateId)
    }
}

Write-Host "`nSummary: $($Created.Count) created, $($Skipped.Count) skipped, $($Invalid.Count) invalid filenames"

if ($Created.Count -gt 0 -and -not $WhatIfPreference) {
    Write-Host "`nNext step — ask your AI for each candidate:"
    foreach ($Cid in $Created) { Write-Host "  Candidate: $Cid" }
    Write-Host @"

  Template prompt:
  "New candidate <CandidateID> applied for $JobKey.
   Here is their resume content: <paste resume>
   Please fill in 04-applicants/<CandidateID>/analysis.md and update metadata.json."
"@
}
