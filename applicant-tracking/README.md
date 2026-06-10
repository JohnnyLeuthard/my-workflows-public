# Applicant Tracking — AI-Assisted Hiring Workflow

> Portable · Vendor-neutral · Works with any AI assistant · No external services required

---

## What Is This?

A complete hiring workflow that lives in your code editor. Drop in a job description, drop in resumes, and use any AI assistant (Claude, Copilot, Cursor, etc.) to parse, analyze, score, and track candidates through your pipeline — all in plain Markdown and JSON files you can read, edit, and version-control.

No SaaS subscriptions. No accounts. No data leaving your machine unless you choose.

---

## Flow Diagram

```
  ┌─────────────────────────────────────────────────────────────┐
  │                 APPLICANT TRACKING WORKFLOW                  │
  └─────────────────────────────────────────────────────────────┘

  PHASE 1          PHASE 2          PHASE 3 / 4
  ┌──────────┐    ┌──────────┐    ┌──────────────────────────────┐
  │  01-job  │    │  02-     │    │ 03-jobs/         04-applicants│
  │  intake  │───▶│ resume   │───▶│ <JobKey>/        <CandidateID>│
  │          │    │  intake  │    │ job-desc.md      analysis.md  │
  │ URL/paste│    │ PDF/paste│    │ metadata.json    metadata.json│
  │ PDF/HTML │    │ _inbox/  │    │ skills-matrix    scoring.md   │
  └──────────┘    └──────────┘    │ scoring.md       interview.md │
                                  └──────────────────────────────┘
                                              │
  PHASE 5                                     ▼
  ┌────────────────────────────────────────────────────────────┐
  │  05-scoring/                                               │
  │  master-applicants.md  ←  ALL candidates, ALL jobs, one   │
  │  scoring-criteria.md      table. Name · Job · Score ·     │
  │                           Offer · Accepted · Start Date   │
  └────────────────────────────────────────────────────────────┘
              │                               │
  PHASE 6     ▼               PHASE 7         ▼
  ┌──────────────────┐    ┌──────────────────────────────────┐
  │  06-interviews/  │    │  07-archive/                     │
  │  Interview logs  │    │  Closed / filled / cancelled     │
  │  per job         │    │  positions (full artifact set)   │
  └──────────────────┘    └──────────────────────────────────┘
```

---

## Prerequisites

| Tool | Minimum | Notes |
|------|---------|-------|
| Python | 3.9+ | Pre-installed on macOS/Linux. `winget install Python.Python.3` on Windows. Only needed for scripts. |
| PowerShell | 7+ | Optional Windows-native alternative. `winget install Microsoft.PowerShell` |
| AI assistant | Any | Claude Code (recommended), VS Code + Copilot, Cursor, Windsurf, etc. |

No Python packages are required for basic AI-only use. Install `requirements.txt` only when running scripts.

---

## Quick Start (5 Steps)

```bash
# 1. Clone or copy this folder to your machine
# 2. Open it in your AI-enabled editor (VS Code, Cursor, Claude Code, etc.)

# 3. (Optional) Install Python script dependencies
pip install -r scripts/requirements.txt

# 4. Explore the demo data to see the full flow
#    Open: 05-scoring/master-applicants.md
#    Then: 03-jobs/2026-06-SeniorDevOpsEngineer-FTE/scoring.md
#    Then: 04-applicants/Smith-Jane-2026-06-01/analysis.md

# 5. Add your first real job
#    Tell your AI: "I have a new job description to add"
#    Your AI reads 01-job-intake/CONTEXT.md and guides you through the rest
```

---

## Multi-Job Support

Run as many open positions simultaneously as you need. Each job gets its own isolated folder in `03-jobs/`. The master pipeline in `05-scoring/master-applicants.md` aggregates all candidates across all jobs with no overlap.

```
03-jobs/
├── 2026-06-SeniorDevOpsEngineer-FTE/    ← Active
├── 2026-06-QAEngineer-Contractor/       ← Active (different type)
└── 2026-05-FrontendDeveloper-FTE/       ← In offer stage
```

---

## Demo Data

This workspace ships with two concurrent job openings and four fictional candidates to show the full lifecycle:

| Candidate | Job | Score | Outcome |
|-----------|-----|-------|---------|
| Smith, Jane | Senior DevOps Engineer | 4 – Strong Fit | Offer accepted, start 2026-07-14 |
| Brown, Michael | Senior DevOps Engineer | 3 – Partial Fit | Rejected post-interview |
| Johnson, Alex | Senior DevOps Engineer | 1 – Unqualified | Screened out at resume |
| Davis, Morgan | QA Engineer (Contract) | 4 – Strong Fit | At interview stage |

---

## For AI Users: Where to Start

- **Claude Code** → Read `CLAUDE.md` then tell Claude what you want to do
- **Copilot / Cursor / Windsurf** → Read `AI-INSTRUCTIONS.md` then ask your AI
- **Manual** → Follow numbered folders 01 → 07 in order

---

## Sharing & Competition

This workflow is designed to be shared. Everything is relative-path linked — zip the folder, push to GitHub, or copy to a USB drive and it works identically on any machine.

A GitHub Pages front end for browsing the master pipeline is planned as a future enhancement. The JSON metadata files (`metadata.json`) in each job and candidate folder are designed to feed that front end when ready.

---

## File Structure

```
applicant-tracking/
├── CLAUDE.md               MWP identity (Claude-specific)
├── CONTEXT.md              Phase router
├── AI-INSTRUCTIONS.md      Generic AI instructions
├── README.md               This file
├── 01-job-intake/          Phase 1: Job description input
├── 02-resume-intake/       Phase 2: Resume input
├── 03-jobs/                Phase 3: Active job postings
├── 04-applicants/          Phase 4: Candidate records
├── 05-scoring/             Phase 5: Scoring hub + master pipeline
├── 06-interviews/          Phase 6: Interview logs
├── 07-archive/             Phase 7: Closed positions
├── references/             Templates, rubrics, standards
└── scripts/                Python + PowerShell automation
```

---

## License

MIT — use freely, fork, adapt, compete. Attribution appreciated but not required.
