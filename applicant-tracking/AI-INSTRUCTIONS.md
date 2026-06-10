# AI Instructions — Applicant Tracking Workflow

> This file is the AI-agnostic version of `CLAUDE.md`. It works with GitHub Copilot, Cursor, Windsurf, Codeium, or any AI assistant that can read workspace files. If you are Claude, prefer `CLAUDE.md` and `CONTEXT.md`.

---

## What This Workspace Is

An AI-assisted hiring workflow stored entirely in Markdown and JSON. No external services required. Works offline. Portable — copy the folder to any machine.

Covers: job postings → resume intake → candidate analysis → scoring → interviews → offer/rejection → archive.

---

## How to Navigate

This workspace uses numbered folders that map to hiring stages in order:

```
01-job-intake/       ← Start here when adding a new job opening
02-resume-intake/    ← Process incoming resumes here
03-jobs/             ← Active job postings live here (one folder per job)
04-applicants/       ← Candidate records live here (one folder per application)
05-scoring/          ← Scoring hub — master pipeline view + scoring criteria
06-interviews/       ← Interview logs per job
07-archive/          ← Closed positions
references/          ← Templates, rubrics, naming standards
scripts/             ← Python and PowerShell automation helpers
```

Read the `CONTEXT.md` inside the relevant numbered folder for step-by-step AI instructions.

---

## Common Tasks

### Add a new job opening
1. Read `01-job-intake/CONTEXT.md`
2. Provide the job description (URL, pasted text, HTML, or PDF text)
3. AI will extract structured data and create `03-jobs/<JobKey>/` files

### Process a resume
1. Read `02-resume-intake/CONTEXT.md`
2. Drop the PDF in `02-resume-intake/_inbox/` OR paste resume text in chat
3. AI will create `04-applicants/<CandidateID>/` files

### Score a candidate
1. Read `05-scoring/CONTEXT.md`
2. Provide the Candidate ID and Job Key
3. AI loads analysis + job criteria and produces a scored record

### Check the full pipeline
- Open `05-scoring/master-applicants.md` — all candidates across all jobs in one table

### Log an interview
1. Open `06-interviews/<JobKey>-interviews.md`
2. Ask AI to append a new interview round row

---

## Key Rules

| Rule | Detail |
|------|--------|
| Candidate ID | `LastName-FirstName-YYYY-MM-DD` — immutable once set |
| Job Key | `YYYY-MM-JobTitlePascalCase-Type` — immutable once set |
| Resume filename | `LastName-Firstname-YYYY-MM-DD.pdf` |
| Scoring formula | `(Core×0.40) + (Experience×0.30) + (Education×0.15) + (TrackRecord×0.15)` — scale 1–5 |
| Multiple jobs | Unlimited concurrent open positions — each gets its own `03-jobs/<JobKey>/` folder |
| Same person, two jobs | Two separate Candidate IDs with different dates |

---

## Scoring Quick Reference

| Score | Interpretation |
|-------|---------------|
| 5 | Excellent fit — prioritize |
| 4 | Strong fit — advance |
| 3 | Partial fit — manager review |
| 2 | Weak fit — decline |
| 1 | Unqualified — decline |

Full rubric: `references/scoring-rubric.md`

---

## File Structure Convention

Each job folder (`03-jobs/<JobKey>/`) contains:
- `job-description.md` — full parsed job posting
- `metadata.json` — machine-readable job data
- `skills-matrix.md` — required vs. nice-to-have skills
- `screening-questions.md` — interview/screening questions
- `scoring.md` — per-job scoring table

Each candidate folder (`04-applicants/<CandidateID>/`) contains:
- `metadata.json` — candidate data and status
- `analysis.md` — AI-generated candidate analysis
- `scoring.md` — weighted score breakdown
- `interview.md` — interview rounds and notes (created when interview is scheduled)

---

## Scripts (Optional — Reduces Token Usage)

Run scripts to create folder scaffolds and update tables mechanically before involving AI for content:

```bash
# Python (cross-platform)
python scripts/new_job.py
python scripts/new_screening.py
python scripts/score_candidates.py --job <JobKey> --candidate <CandidateID>

# PowerShell (Windows-native)
pwsh scripts/ps/Start-NewJob.ps1
pwsh scripts/ps/Start-NewScreening.ps1
```

See `scripts/README.md` for full usage.
