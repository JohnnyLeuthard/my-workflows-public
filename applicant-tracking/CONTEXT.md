# Applicant Tracking — Root Router

Read the user's request and route to the correct phase folder. **Do not load any phase files until you have routed.**

## Routing Rules

| If the request involves... | Route to... |
|----------------------------|-------------|
| Adding a job, processing a job description (URL / paste / PDF / HTML) | [01-job-intake/CONTEXT.md](01-job-intake/CONTEXT.md) |
| Processing resumes, new candidates, resume intake | [02-resume-intake/CONTEXT.md](02-resume-intake/CONTEXT.md) |
| Active job openings, job details, skills matrix, per-job scoring table | [03-jobs/](03-jobs/) — open the specific `<JobKey>/` subfolder |
| Candidate files, analysis, candidate-level scoring | [04-applicants/](04-applicants/) — open the specific `<CandidateID>/` subfolder |
| Scoring a candidate, updating scores, master applicant pipeline | [05-scoring/CONTEXT.md](05-scoring/CONTEXT.md) |
| Interview scheduling, interview notes, interview logs | [06-interviews/](06-interviews/) |
| Archiving a closed, filled, or cancelled position | [07-archive/](07-archive/) |
| Templates, rubrics, naming standards, reference material | [references/_INDEX.md](references/_INDEX.md) |
| Running scripts, automation, batch operations | [scripts/README.md](scripts/README.md) |

## Global Constraints

- **Candidate ID is immutable** once set — it is the foreign key across all phases.
- **Job Key is immutable** once set — never rename a job folder after creation.
- **Naming standards are enforced** — see `references/naming-standards.md` for patterns.
- **No cross-job contamination** — each job folder in `03-jobs/` is fully self-contained.
- **Relative paths only** — all links between files must use relative paths so archives remain portable.
- **Scripts handle structure; AI handles content** — see `CLAUDE.md` for the token-saving contract.

## Multi-Job Note

Multiple jobs can be open simultaneously. `03-jobs/` holds one subfolder per open position with no limit on concurrency. `05-scoring/master-applicants.md` is the single cross-job view.

## Out of Scope

This workspace does not cover ATS platform APIs, email/calendar integration, payroll/HRIS, or legal/compliance advice.

## Adding a New Job

1. Follow [01-job-intake/CONTEXT.md](01-job-intake/CONTEXT.md) to create the job folder.
2. Add a row to the routing table above if a new job type or special routing rule is needed.
