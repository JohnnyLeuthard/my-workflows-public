# Scripts — Usage Guide

Scripts handle **mechanical work** (folder creation, file scaffolding, naming enforcement, table updates) so the AI only handles **content** (parsing, analysis, scoring narratives). This keeps token usage low and keeps the AI focused on intelligence, not file management.

---

## Prerequisites

### Python (cross-platform — macOS, Linux, Windows)

```bash
# Check Python version (3.9+ required)
python3 --version

# Install dependencies (only needed for PDF extraction and URL fetching)
pip install -r scripts/requirements.txt

# No dependencies required for basic scaffold operations (new_job, new_screening, new_interview, archive_job)
```

### PowerShell (Windows-native, also available on macOS/Linux via pwsh)

```bash
# Check PowerShell version (7+ required)
pwsh --version

# Install on macOS/Linux
brew install --cask powershell   # macOS
sudo apt install powershell      # Ubuntu/Debian
```

No PowerShell modules need to be installed — all scripts use built-in cmdlets only.

---

## Script Reference

### `new_job.py` / `Start-NewJob.ps1`

Scaffold a new job folder in `03-jobs/`.

```bash
# Python
python scripts/new_job.py --title "Senior DevOps Engineer" --type FTE
python scripts/new_job.py --title "QA Engineer" --type Contractor --whatif

# PowerShell
pwsh scripts/ps/Start-NewJob.ps1 -Title "Senior DevOps Engineer" -Type FTE
pwsh scripts/ps/Start-NewJob.ps1 -Title "QA Engineer" -Type Contractor -WhatIf
```

**What it creates:**

```
03-jobs/2026-06-SeniorDevOpsEngineer-FTE/
├── job-description.md       (stub — AI fills in)
├── metadata.json            (stub — AI fills in)
├── skills-matrix.md         (stub — AI fills in)
├── screening-questions.md   (stub — AI fills in)
└── scoring.md               (header only)
```

**After running:** Ask AI to populate the stubs using the job description text.

---

### `new_screening.py` / `Start-NewScreening.ps1`

Scan `02-resume-intake/_inbox/` and scaffold candidate folders.

```bash
# Drop renamed PDFs (LastName-Firstname-YYYY-MM-DD.pdf) in 02-resume-intake/_inbox/ first

# Python
python scripts/new_screening.py --job 2026-06-SeniorDevOpsEngineer-FTE
python scripts/new_screening.py --job 2026-06-SeniorDevOpsEngineer-FTE --whatif
python scripts/new_screening.py --job 2026-06-SeniorDevOpsEngineer-FTE --force

# PowerShell
pwsh scripts/ps/Start-NewScreening.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE"
pwsh scripts/ps/Start-NewScreening.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" -WhatIf
```

**What it creates for each valid PDF:**

```
04-applicants/Smith-Jane-2026-06-01/
├── metadata.json    (stub — AI fills in)
├── analysis.md      (stub — AI fills in)
└── scoring.md       (header only — AI fills in scores)
```

**After running:** Ask AI to fill in `analysis.md` for each candidate by pasting their resume text.

---

### `score_candidates.py`

After AI has filled in scoring.md, propagate scores to per-job table and master pipeline.

```bash
# Python only (no PowerShell equivalent — table parsing is complex in PS)
python scripts/score_candidates.py --job 2026-06-SeniorDevOpsEngineer-FTE --candidate Smith-Jane-2026-06-01
python scripts/score_candidates.py --job 2026-06-SeniorDevOpsEngineer-FTE --all
python scripts/score_candidates.py --job 2026-06-SeniorDevOpsEngineer-FTE --all --whatif
```

**What it updates:**

- `03-jobs/<JobKey>/scoring.md` — per-job table row
- `05-scoring/master-applicants.md` — master pipeline row
- `04-applicants/<CandidateID>/metadata.json` — score and recommendation fields

---

### `new_interview.py` / `Start-NewInterview.ps1`

Log an upcoming interview and scaffold the candidate's interview record.

```bash
# Python
python scripts/new_interview.py --job 2026-06-SeniorDevOpsEngineer-FTE \
    --candidate Smith-Jane-2026-06-01 --round "Phone Screen" \
    --interviewer "Jordan Ellis" --date 2026-06-05

# PowerShell
pwsh scripts/ps/Start-NewInterview.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" `
    -CandidateId "Smith-Jane-2026-06-01" -Round "Phone Screen" `
    -Interviewer "Jordan Ellis" -InterviewDate "2026-06-05"
```

**What it updates:**

- `06-interviews/<JobKey>-interviews.md` — new log row
- `04-applicants/<CandidateID>/interview.md` — new round section stub
- `04-applicants/<CandidateID>/metadata.json` — status = interview

---

### `archive_job.py` / `Archive-Job.ps1`

Archive a completed or closed position.

```bash
# Python
python scripts/archive_job.py --job 2026-06-SeniorDevOpsEngineer-FTE --reason filled
python scripts/archive_job.py --job 2026-06-SeniorDevOpsEngineer-FTE --reason filled --whatif

# PowerShell
pwsh scripts/ps/Archive-Job.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" -Reason filled
pwsh scripts/ps/Archive-Job.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" -Reason filled -WhatIf
```

---

## Typical Workflow (with scripts)

```bash
# 1. Add a new job
python scripts/new_job.py --title "Backend Engineer" --type FTE
# → Ask AI to populate the job files

# 2. Drop resumes in 02-resume-intake/_inbox/ and scaffold candidates
python scripts/new_screening.py --job 2026-06-BackendEngineer-FTE
# → Ask AI to fill in analysis.md for each candidate (paste resume text)

# 3. Ask AI to score each candidate (AI fills in scoring.md)
# → Then run score_candidates.py to propagate scores to tables
python scripts/score_candidates.py --job 2026-06-BackendEngineer-FTE --all

# 4. Schedule an interview
python scripts/new_interview.py --job 2026-06-BackendEngineer-FTE \
    --candidate Doe-Jane-2026-06-10 --round "Phone Screen" --interviewer "Your Name"
# → Ask AI to populate interview questions in interview.md

# 5. Archive when done
python scripts/archive_job.py --job 2026-06-BackendEngineer-FTE --reason filled
# → Ask AI to complete status.md summary
```

---

## All Scripts Support `--whatif` / `-WhatIf`

Every script supports a dry-run mode that shows what would happen without making changes. Always run with `--whatif` first on a new setup.
