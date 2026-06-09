## Script Specifications

### 8.1 `Start-NewScreening.ps1`

#### Parameters
- `JobFolder` required
- `Force` optional
- `WhatIf` optional

#### Required Behavior
1. Validate job and resume folders exist.
2. Ensure output folders exist: `applicants`, `scoring`, `interviews`, `tmp`.
3. Create timestamped backup folder.
4. Scan `*.pdf` resumes.
5. Validate naming regex for resumes.
6. Parse Candidate ID from filename.
7. Create candidate analysis artifact(s).
8. Create/refresh master scoring table.
9. Create interview log if missing.
10. Log all operations with timestamps.

#### Validation
- Invalid filenames are skipped with warning.
- Existing candidate files are skipped unless `Force`.
- No valid resumes equals graceful no-op with warning.

---

### 8.2 `Start-NewInterview.ps1`

#### Parameters
- `JobFolder` required
- `Candidates` required string array
- `Interviewer` required
- `InterviewDate` optional
- `InterviewTime` optional
- `QuestionBankPath` optional
- `CopyQuestions` optional
- `Force` optional
- `WhatIf` optional

#### Run

```powershell
.\scripts\Start-NewInterview.ps1 -JobFolder "YYYY-MM-JobTitle-Type" -Candidates @("LastName-FirstName-YYYY-MM-DD") -Interviewer "Hiring Manager"
```

#### Expected Outputs
- Interview log rows added or updated
- Scoring status updated when format allows
- Candidate `interview.md` created/appended
- Optional candidate question sheets copied if enabled
- Backup log generated

---

### Phase F - Archive

When filled/cancelled/on-hold/withdrawn:

1. Move all artifacts to `archive/<JobKey>/`
2. Create `status.md`
3. Verify links and completeness
4. Clear active folders for that job

---

### 8.3 `New-JobQuestionBank.ps1`

#### Purpose
Generate job-level interview question bank markdown with stable `Question ID` values.

#### Behavior
- Derive topics from job description bullets when possible
- Fallback to default topics if none found
- Emit table with:
  - Question ID
  - Category
  - Question text
  - Required flag
- Mark required question misses as warning-level only

---

### 8.4 `Copy-CandidateQuestionSet.ps1`

#### Purpose
Copy job-level question bank to candidate-specific `interview-questions.md` files.

#### Behavior
- Create candidate folder if missing
- Write unified interview-question table
- Optionally append a link in `interview.md`

---

## 9 Data Model

### 9.1 Candidate Metadata (`metadata.json`)

```json
{
  "candidate_name": "First Last",
  "phone": "string",
  "email": "string",
  "location": "string",
  "citizenship": "string|null",
  "date_added": "YYYY-MM-DD",
  "screening_status": "resume_received|screening|interview|offer|rejected",
  "analysis_completed": false,
  "interview_scheduled": null,
  "interview_date": null,
  "interview_notes": null,
  "overall_score": null,
  "recommendation": null
}
```

### 9.2 Job Metadata (`metadata.json`)

#### FTE Example

```json
{
  "jobTitle": "Lead Backend Engineer",
  "type": "FTE",
  "dateOpened": "YYYY-MM-DD",
  "hiringManager": "Name",
  "requiredSkills": ["Skill A", "Skill B"],
  "niceToHaveSkills": ["Skill C"],
  "yearsRequired": 5,
  "complianceRequired": true,
  "predefinedQuestions": true,
  "questionsFile": "screening-questions.md"
}
```

#### Contractor Example

```json
{
  "jobTitle": "QA Engineer",
  "type": "Contractor",
  "dateOpened": "YYYY-MM-DD",
  "hiringManager": "Name",
  "contractFirms": [
    {
      "name": "Agency Name",
      "rep": "Recruiter Name",
      "email": "rep@example.com",
      "phone": "(000) 000-0000"
    }
  ],
  "requiredSkills": ["Skill A", "Skill B"],
  "yearsRequired": 3,
  "contractDuration": "12 months",
  "rate": "TBD"
}
```

---

## 10 Scoring Rubric and Formula

Use 1-5 scale with weighted categories:

- Core Skills: 40%
- Experience: 30%
- Education/Certs: 15%
- Track Record: 15%

Formula:

```text
Score = (Core * 0.40) + (Experience * 0.30) + (Education * 0.15) + (TrackRecord * 0.15)
```

Round to nearest whole number for summary decisions.

### Interpretation

- 5: Excellent fit
- 4: Strong fit
- 3: Partial fit
- 2: Weak fit
- 1: Unqualified

---

## 11 Interview Question Standard

Use the same table columns for all job types:

| Round | Question ID | Category | Question | Required | Asked | Response Summary | Rating 1-5 | Follow-up Needed | Notes |
|---|---|---|---|---|---|---|---|---|---|

### Rules

- Keep `Question ID` stable
- Missing required question equals warning/follow-up, not hard failure
- Append new rounds in same `interview.md`

---

## 12 Data Linking Rules

1. Every scoring row must point to a valid applicant analysis file.
2. Every applicant analysis must link back to resume source.
3. Interview log entries should map to candidates in scoring.
4. Use relative paths so archives remain portable.
5. Avoid manual renames. Use script-driven updates.

---

## 13 Safety, Logging, and Rollback

Mandatory controls:

- Backup before write operations
- `WhatIf` support in all scripts
- Structured log lines with timestamp and level

---

## 17 Portable Prompt You Can Feed to Claude on Another Computer

Use this exact prompt:

```text
Build a complete, vendor-neutral applicant-tracking workflow in PowerShell and Markdown.

Requirements:

1) Create this structure:
applicant-tracking/
CLAUDE.md
README.md
AUTOMATION-RULES.md
AUTOMATION-SUMMARY.md
job-descriptions/
resumes/
applicants/
interviews/
scoring/
references/
scripts/
archive/
tmp/

2) Implement scripts:
scripts/Start-NewScreening.ps1
scripts/Start-NewInterview.ps1
scripts/New-JobQuestionBank.ps1
scripts/Copy-CandidateQuestionSet.ps1

3) Enforce naming:
Job key: YYYY-MM-JobTitle-Type
Candidate ID: LastName-FirstName-YYYY-MM-DD
Resume: LastName-Firstname-YYYY-MM-DD.pdf

4) Screening script must:
- Validate folders
- Scan resumes
- Validate names
- Create candidate analysis files
- Create scoring file
- Create interview log
- Create backup and logs
- Support -WhatIf and -Force

5) Interview script must:
- Validate candidates against scoring
- Update interview log
- Update scoring status when possible
- Create/append applicants/<CandidateID>/interview.md
- Optionally copy question bank to interview-questions.md
- Support -WhatIf and -Force

6) Add references:
analysis-template.md
archive-checklist.md
fte-vs-contractor-rules.md
interview-question-template.md
naming-standards.md
scoring-rubric.md

7) Use generic brand workflow naming:
replace any WFBrand naming with BrandKit references.

8) Remove all company-specific references from content.

9) Provide sample test data and runbook instructions.
```

---

## 18 Neutral Brand Integration Note

For report styling/export guidance, depend on a generic workflow named `BrandKit`.

Do not hardcode organization names, logos, legal text, or protected brand language in applicant-tracking artifacts.

---

## 19 Final Notes

This specification intentionally favors:

- Portability
- Low tooling dependency
- Transparent Markdown records
- Deterministic scripting
- Easy AI regeneration on a clean machine

If needed, this can be extended later with:

- CSV/JSON exports
- Calendar integration
- Document generation pipelines
- ATS API synchronization

# Applicant Tracking Workflow - Full Recreation Brief
## Portable, Vendor-Neutral

## 1) Purpose

This document is a complete, portable specification for rebuilding the applicant-tracking workflow on a new machine from scratch.

It is intentionally vendor-neutral and removes company-specific references.

Use this brief as the single input for another AI assistant to recreate:

- Folder structure
- Templates
- Automation scripts
- Naming conventions
- Data linking rules
- Safety and backup behavior
- Interview and scoring workflow

---

## 2) Scope and Outcomes

### In Scope

- Job opening setup (job descriptions, skills, screening questions)
- Resume intake and normalization
- Candidate analysis generation
- Master scoring table generation
- Interview scheduling updates
- Candidate interview packet creation
- Optional question bank creation and copy-to-candidate sheets
- Archive process and records retention

### Out of Scope

- ATS platform integration APIs
- Email/calendar integration
- Payroll/HRIS integration
- Legal advice or jurisdiction-specific hiring compliance

### Target Outcome

A Markdown + PowerShell workflow where a user can:

1. Add a job
2. Drop resumes into a folder
3. Run one script to generate candidate analysis + scoring + interview log
4. Run another script to schedule interviews and maintain linked records
5. Archive a completed position cleanly

---

## 3) Generic Naming and Terminology

Replace any legacy brand naming with generic naming:

- Old workflow name: WFBrand
- New neutral workflow name: BrandKit

Use BrandKit as the cross-workflow dependency for branding/styling guidance (PDF exports, templates, tone), while keeping applicant tracking operationally independent.

---

## 4) Required Top-Level Structure

```text
applicant-tracking/
│
├── CLAUDE.md
├── README.md
├── AUTOMATION-RULES.md
├── AUTOMATION-SUMMARY.md
│
├── job-descriptions/
├── resumes/
├── applicants/
├── interviews/
├── scoring/
├── references/
├── scripts/
├── archive/
└── tmp/
```

---

## 5) Required Reference Files

```text
references/
│
├── analysis-template.md
├── archive-checklist.md
├── fte-vs-contractor-rules.md
├── interview-question-template.md
├── naming-standards.md
└── scoring-rubric.md
```

---

## 6) Naming Standards

### 6.1 Job Folder

```text
YYYY-MM-JobTitle-Type
```

Examples:

```text
2026-06-LeadBackendEngineer-FTE
2026-06-QAEngineer-Contractor
```

### 6.2 Candidate ID

```text
LastName-FirstName-YYYY-MM-DD
```

Example:

```text
Smith-John-2026-06-09
```

### 6.3 Resume Filename

```text
LastName-Firstname-YYYY-MM-DD.pdf
```

### 6.4 Interview Log Filename

```text
YYYY-MM-JobTitle-Type-interviews.md
```

### 6.5 Scoring Filename

```text
YYYY-MM-JobTitle-Type-scoring.md
```

### Integrity Rule

Treat Candidate ID as immutable.

It is the foreign key linking:

- Resume
- Analysis
- Scoring rows
- Interview records

---

## 7) End-to-End Workflow

### Phase A - Job Setup

1. Create job folder and baseline files in `job-descriptions/`.
2. Create matching resume folder in `resumes/`.
3. Populate `metadata.json` and `skills-matrix.md`.

### Phase B - Resume Intake

1. Normalize all resumes to PDF.
2. Enforce filename pattern.
3. Place files in matching job resume folder.

### Phase C - Screening Bootstrap

Run:

```powershell
.\scripts\Start-NewScreening.ps1 -JobFolder "YYYY-MM-JobTitle-Type"
```

Expected outputs:

- Candidate analysis files created
- Master scoring file created
- Interview log created
- Backup created in `tmp/backup-YYYY-MM-DD-HHMM/`
- Logs written to `tmp/screening-log-YYYY-MM-DD.txt`

### Phase D - Scoring and Manager Review

1. Open master scoring file.
2. Review each linked candidate analysis.
3. Update score/status/highlights.
4. Mark interview targets.

### Phase E - Interview Scheduling

Run:

```powershell
.\scripts\Start-NewInterview.ps1 -JobFolder "YYYY-MM-JobTitle-Type" -Candidates @("LastName-FirstName-YYYY-MM-DD") -Interviewer "Hiring Manager"
```

Expected outputs:

- Interview log rows added or updated
- Scoring status updated when format allows
- Candidate `interview.md` created/appended
- Optional candidate question sheets copied if enabled
- Backup log generated

### Phase F - Archive

When filled/cancelled/on-hold/withdrawn:

1. Move all artifacts to `archive/<JobKey>/`
2. Create `status.md`
3. Verify links and completeness
4. Clear active folders for that job

---

## 8) Script Specifications

### 8.1 Start-NewScreening.ps1

#### Parameters

- JobFolder (required)
- Force (optional)
- WhatIf (optional)

#### Required Behavior

1. Validate job and resume folders exist.
2. Ensure output folders exist (`applicants`, `scoring`, `interviews`, `tmp`).
3. Create timestamped backup folder.
4. Scan `*.pdf` resumes.
5. Validate naming regex for resumes.
6. Parse Candidate ID from filename.
7. Create candidate analysis artifact(s).
8. Create/refresh master scoring table.
9. Create interview log if missing.
10. Log all operations with timestamps.

#### Validation

- Invalid filenames skipped with warning
- Existing candidate files skipped unless `-Force`
- No valid resumes equals graceful no-op with warning

---

### 8.2 Start-NewInterview.ps1

#### Parameters

- JobFolder (required)
- Candidates (required string array)
- Interviewer (required)
- InterviewDate (optional)
- InterviewTime (optional)
- QuestionBankPath (optional)
- CopyQuestions (optional)
- Force (optional)
- WhatIf (optional)

#### Required Behavior

1. Resolve scoring file for job.
2. Ensure interview log exists (create if missing).
3. Validate candidate IDs exist in scoring context.
4. Backup scoring/interview/candidate packet files.
5. Add or update interview rows.
6. Create/append candidate `interview.md` cumulative rounds.
7. Optionally invoke copy of question bank into candidate sheets.
8. Update scoring status from Applied to Interview where table shape is standard.

#### Compatibility Rule

If scoring file format is custom/non-standard:

- Do not fail
- Log warning
- Continue

---

### 8.3 New-JobQuestionBank.ps1

#### Purpose

Generate job-level interview question bank markdown with stable Question ID values.

#### Behavior

- Derive topics from job description bullets when possible
- Fallback to default topics if none found
- Emit table with:
  - Question ID
  - Category
  - Question text
  - Required flag
- Mark required question misses as warning-level only

---

### 8.4 Copy-CandidateQuestionSet.ps1

#### Purpose

Copy job-level question bank to candidate-specific `interview-questions.md`.

#### Behavior

- Create candidate folder if missing
- Write unified interview-question table
- Optionally append link in candidate interview record

---

## 9) Data Model

### 9.1 Candidate Metadata (`metadata.json`)

```json
{
  "candidate_name": "First Last",
  "phone": "string",
  "email": "string",
  "location": "string",
  "citizenship": "string|null",
  "date_added": "YYYY-MM-DD",
  "screening_status": "resume_received|screening|interview|offer|rejected",
  "analysis_completed": false,
  "interview_scheduled": null,
  "interview_date": null,
  "interview_notes": null,
  "overall_score": null,
  "recommendation": null
}
```

### 9.2 Job Metadata (`metadata.json`)

#### FTE Example

```json
{
  "jobTitle": "Lead Backend Engineer",
  "type": "FTE",
  "dateOpened": "YYYY-MM-DD",
  "hiringManager": "Name",
  "requiredSkills": ["Skill A", "Skill B"],
  "niceToHaveSkills": ["Skill C"],
  "yearsRequired": 5,
  "complianceRequired": true,
  "predefinedQuestions": true,
  "questionsFile": "screening-questions.md"
}
```

#### Contractor Example

```json
{
  "jobTitle": "QA Engineer",
  "type": "Contractor",
  "dateOpened": "YYYY-MM-DD",
  "hiringManager": "Name",
  "contractFirms": [
    {
      "name": "Agency Name",
      "rep": "Recruiter Name",
      "email": "rep@example.com",
      "phone": "(000) 000-0000"
    }
  ],
  "requiredSkills": ["Skill A", "Skill B"],
  "yearsRequired": 3,
  "contractDuration": "12 months",
  "rate": "TBD"
}
```


