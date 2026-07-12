# Claude Manager — Next Steps (planned, not yet designed)

Planned enhancements recorded here before design. Each item, when picked up, goes through the
normal design flow: update `SPEC.md` **and** append a `DECISIONS.md` entry — this file only
holds the intent so it isn't lost. Remove an item from this list when its design lands.

## Open

| Item | Intent | Notes |
|------|--------|-------|
| `clean.js` | Guided deletion: dry-run by default, `--execute` to act, `--only-<category>` / `--older-than-days` / `--keep-count` filters, deletion log to `reports/` | Interface already sketched in `../SCRIPTS.md`; open design questions: category registry (reuse scan.js `FOLDER_METADATA`?), what "old" means per folder, interactive confirm mode |
| `audit.js --deep` | Opt-in pattern scan of `projects/**/*.jsonl` transcripts | Deferred from the 2026-07-11 review (S4 item 3). Slow and false-positive-heavy; needs the existing size caps plus probably per-file match limits and a progress indicator. Off by default, always |
| Regenerate `example-dashboard.html` | Bring the scan.js demo up to current output (heuristic label, token-aware client JS) | Cosmetic staleness only; regenerate via the staged-fake-HOME flow the audit example already uses |
| `--out <path>` for reports | Let users direct generated reports outside the (possibly cloud-synced) repo | Review item S5 option B — skipped as not-needed once HTML withholds secret values; revisit only if someone asks |
| Phase 3 visual interface | Interactive browse/manage UI (browser control panel; projects tab with per-project drill-down) | Ideas parked in `../TASKS.md` "Phase 3" and "Full Claude Folder Audit" sections; nothing designed |

## Resolved

| Item | Outcome | Where |
|------|---------|-------|
| Security/design hardening backlog | **Designed and built** (2026-07-11): all 14 findings from the review — server token/Host/path hardening, Anthropic key regex fix + new detectors, exit codes, read caps, shared lib, pure-JS sizes, heuristic labels, dedup, package.json | `../SECURITY-REVIEW-PLAN.md` (ledger), `DECISIONS.md` D11–D22 |
| Audit coverage + report hygiene | **Designed and built** (2026-07-11): top-level config scan, permission checks, "Not scanned" disclosure, HTML value withholding, cloud-sync warnings | `DECISIONS.md` D11–D13 |
