# Research Lab — Next Steps (proposed, not yet decided)

Reliability suggestions and criticisms raised in review (2026-07-05), recorded here before the
lab is built so they can be worked through one at a time. Each item, when picked up, goes
through the normal design flow: update `SPEC.md` **and** append a `DECISIONS.md` entry — this
file only holds the intent so it isn't lost. Remove an item (or move it to Resolved) when its
design lands or it is explicitly declined.

**No open items.**

## Resolved

### A. Reliability hardening — all designed into the spec 2026-07-05, before any build

| Item | Outcome | Where |
|------|---------|-------|
| A1 Quote-anchored citations | **Designed in**: every citation carries a verbatim quote + access date. | `SPEC.md` req 3 (rule 6), req 8; `DECISIONS.md` D14 |
| A2 Fetched-only rule | **Designed in**: cite only sources actually opened and read; snippets are leads; unreachable → `unsupported (unreachable)`. | `SPEC.md` req 3 (rule 7); `DECISIONS.md` D14 |
| A3 Verify against sources, not summaries | **Designed in**: phase-2 verifiers re-fetch and re-read; findings say *what* to check, never what's true; fresh-session tip in HOW-TO-USE. | `SPEC.md` req 5 (phase 2), req 11; `DECISIONS.md` D15 |
| A4 `not-covered` verdict for restricted specialists | **Designed in**: silence from a restricted list is `not-covered`, never a negative; verdict scale extended. | `SPEC.md` req 3 (rule 5), req 6; `DECISIONS.md` D16 |
| A5 Independence rule for corroboration | **Designed in**: corroboration = independent originators; origin-tracing is the source-analyst's job. | `SPEC.md` req 6, req 2 (starter table); `DECISIONS.md` D17 |
| A6 Fetched content is data, never instructions | **Designed in**: prompt-injection guard in the source rules and the specialist protocol; agent-addressed text is a reportable red flag. | `SPEC.md` req 3 (rule 9), protocol scaffold; `DECISIONS.md` D18 |
| A7 Freshness stamps | **Designed in**: "As of \<date\>" atop every packet; access dates on every citation and source row. | `SPEC.md` req 8; `DECISIONS.md` D19 |

### B. Workspace-level notes — all resolved 2026-07-05

| Item | Outcome | Where |
|------|---------|-------|
| B1 Pattern duplication across labs | **Implemented**: a shared-pattern registry now tracks every cross-lab pattern — canonical copy, adopters, and the update rule (change the canonical, then explicitly update or intentionally hold back each adopter). Labs still copy, never link. | `ICM-Notes/lab-patterns.md`; root `CONTEXT.md` points at it |
| B2 Human is the pipeline's throughput | **Recorded as a workspace principle** (checkpoint asymmetry): if checkpoints ever loosen, loosen the content labs' — never the research lab's; a wrong verdict poisons everything downstream that cites it. | `ICM-Notes/lab-patterns.md`, Workspace Principles #1 |
| B3 Commit the seeds | **Handled by Johnny's workflow**: he commits and pushes via the GitHub app. debate-lab + social-media seeds committed 2026-07-05; research-lab seed goes in with his next push. No attribution trailers in commit messages. | Johnny's GitHub-app workflow |
| B4 OneDrive sync caution | **Acknowledged, temporary**: this laptop setup is travel-only; real work happens on the main computer, synced through GitHub. OneDrive will be dropped from the path eventually — no lab accommodation needed. | — |
