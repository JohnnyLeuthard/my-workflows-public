# Naming Standards

All identifiers in this workflow are **immutable once set**. They act as foreign keys linking records across phase folders. Never rename a Job Key folder or Candidate ID folder after creation.

---

## Job Key

**Pattern:** `YYYY-MM-JobTitlePascalCase-Type`

| Part | Rule | Example |
|------|------|---------|
| `YYYY-MM` | Year and month the job opened | `2026-06` |
| `JobTitlePascalCase` | Exact job title in PascalCase — no spaces, capitalize each word | `SeniorDevOpsEngineer` |
| `Type` | `FTE` for full-time employee, `Contractor` for contract/temp | `FTE` |

**Full examples:**
```
2026-06-SeniorDevOpsEngineer-FTE
2026-06-QAEngineer-Contractor
2026-07-DataScienceLead-FTE
2025-11-FrontendDeveloper-Contractor
```

**Collision rule:** If two jobs share the same title and month, append `-2`, `-3`, etc.:
```
2026-06-SoftwareEngineerII-FTE
2026-06-SoftwareEngineerII-FTE-2
```

**Forbidden characters:** spaces, slashes, dots, underscores, commas, parentheses.

---

## Candidate ID

**Pattern:** `LastName-FirstName-YYYY-MM-DD`

| Part | Rule | Example |
|------|------|---------|
| `LastName` | Candidate's last name, PascalCase, no spaces | `Smith` |
| `FirstName` | Candidate's first name, PascalCase, no spaces | `Jane` |
| `YYYY-MM-DD` | Date the resume was **received** (not scored) | `2026-06-01` |

**Full examples:**
```
Smith-Jane-2026-06-01
Brown-Michael-2026-06-03
VanDerBerg-Anna-2026-06-15   ← compound last names use no space
O'Brien-Patrick-2026-06-20   ← apostrophes removed: OBrien-Patrick-2026-06-20
```

**Apostrophe / hyphen rule:** Strip apostrophes. If the last name already contains a hyphen (e.g., Martinez-Lopez), keep it as-is: `MartinezLopez-Sofia-YYYY-MM-DD` (flatten the hyphen in the last name).

**Same person, two jobs:** Two different application records with different Candidate IDs (different dates). They are independent records.

---

## Resume Filename

**Pattern:** `LastName-Firstname-YYYY-MM-DD.pdf`

Must match the Candidate ID exactly (with `.pdf` extension). No spaces.

```
Smith-Jane-2026-06-01.pdf
Brown-Michael-2026-06-03.pdf
```

Resumes that do not match this pattern are flagged with a warning and must be renamed before processing.

---

## Interview Log Filename

**Pattern:** `<JobKey>-interviews.md`

```
2026-06-SeniorDevOpsEngineer-FTE-interviews.md
2026-06-QAEngineer-Contractor-interviews.md
```

Lives in `06-interviews/`. One file per job.

---

## Per-Job Scoring Filename

Scoring files live **inside the job folder** as `scoring.md`:

```
03-jobs/2026-06-SeniorDevOpsEngineer-FTE/scoring.md
```

There is no separate filename pattern — it is always `scoring.md` within the job folder.

---

## Archive Folder

When archiving, the entire job folder moves to `07-archive/<JobKey>/`:

```
07-archive/2026-06-SeniorDevOpsEngineer-FTE/
```

Candidate folders for that job move to `07-archive/<JobKey>/applicants/<CandidateID>/`.

---

## Summary Table

| Artifact | Pattern | Location |
|----------|---------|----------|
| Job folder | `YYYY-MM-JobTitlePascalCase-Type` | `03-jobs/` |
| Candidate folder | `LastName-FirstName-YYYY-MM-DD` | `04-applicants/` |
| Resume file | `LastName-Firstname-YYYY-MM-DD.pdf` | `02-resume-intake/_inbox/` |
| Interview log | `<JobKey>-interviews.md` | `06-interviews/` |
| Per-job scoring | `scoring.md` (inside job folder) | `03-jobs/<JobKey>/` |
| Archive job | `<JobKey>/` | `07-archive/` |
