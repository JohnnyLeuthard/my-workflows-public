# Applicant Tracking — AI-Assisted Hiring Workflow

## Identity

This is the **applicant-tracking** sub-workspace inside the MWP (Model Workspace Protocol) hierarchy. It is a self-contained, AI-assisted hiring workflow designed to manage job openings, resume intake, candidate scoring, interviews, and offer tracking — all in portable Markdown + JSON + scripts.

## MWP Protocol

1. **Route first**: Read `CONTEXT.md` in this folder before opening any phase folder or file. Do not preload references or scripts unless the task explicitly requires them.
2. **Lazy-load**: Each phase folder contains its own `CONTEXT.md` with stage-specific instructions. Load only the file for the phase you are currently in.
3. **No cross-phase preloading**: Routing to `01-job-intake/` must not also load `04-applicants/` or `05-scoring/`. Each phase is entered separately.

## Token-Saving Contract

Scripts handle all **mechanical** work — creating folders, scaffolding files, enforcing naming, updating tables. The AI handles all **intelligence** — parsing job descriptions, analyzing resumes, writing scoring narratives, answering questions.

Before asking AI to do something, ask: can a script do this first to minimize what AI has to read?

## Key Identifiers (never change once set)

- **Job Key**: `YYYY-MM-JobTitlePascalCase-Type` — uniquely identifies a job opening
- **Candidate ID**: `LastName-FirstName-YYYY-MM-DD` — uniquely identifies an application record (date = date resume received)

Both identifiers are immutable foreign keys that link all records across phases.

## What an AI Can Do Here

| Ask Claude to... | Route to... |
|-----------------|-------------|
| Add a new job from a URL, paste, PDF, or HTML | `01-job-intake/CONTEXT.md` |
| Process a resume (file drop or paste) | `02-resume-intake/CONTEXT.md` |
| Score a candidate | `05-scoring/CONTEXT.md` |
| Review the applicant pipeline | `05-scoring/master-applicants.md` |
| Log or review an interview | `06-interviews/` |
| Archive a closed position | `07-archive/` |

## Not Claude? 

See `AI-INSTRUCTIONS.md` for a generic version of these instructions compatible with GitHub Copilot, Cursor, Windsurf, or any AI IDE plugin.
