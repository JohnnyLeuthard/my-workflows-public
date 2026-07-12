# Claude Manager — Design Seed (Router)

Route requests about this folder using the table below.

## Routing Rules

| If the request involves... | Route to... |
|---|---|
| Building the project out, rebuilding it, repairing missing files | [SPEC.md](SPEC.md) — follow its **Build & Integration Protocol** section |
| Why the project is designed a certain way, evaluating a design change | [DECISIONS.md](DECISIONS.md), with [SPEC.md](SPEC.md) for the current outcome |
| Changing the design | Update [SPEC.md](SPEC.md) **and** append an entry to [DECISIONS.md](DECISIONS.md) — never rewrite old entries |
| The 2026-07-11 security review — findings, acceptance criteria, what landed | [../SECURITY-REVIEW-PLAN.md](../SECURITY-REVIEW-PLAN.md) (ledger); summary reasoning in [DECISIONS.md](DECISIONS.md) D11–D22 |
| Actually using the tools — scanning, auditing, cleaning `~/.claude` | The built project's own docs: `../README.md` (reference), `../SCRIPTS.md` (flags/usage). If the project is not built yet, offer to build it from [SPEC.md](SPEC.md) first |
| What `~/.claude` folders mean, what's safe to delete | `../README.md` — the knowledge base itself, not a design question |
| Planned future enhancements, or what happened to a previously planned item | [NEXT-STEPS.md](NEXT-STEPS.md) — intent only; designing an item means updating SPEC.md + DECISIONS.md |
| Roadmap/progress bookkeeping | `../TASKS.md` (always updated when work lands — a project workflow rule) |

## Build Quick-Reference

The full protocol lives in `SPEC.md` (Build & Integration Protocol). In short:

1. **Locate**: if this folder's parent is the project folder (even empty), build into the
   parent. If `_design/` was dropped bare into a workspace root, create `claude-manager/`
   beside it, move `_design/` inside, and build there.
2. **Build**: `scripts/lib/common.js` → `scan.js` → `audit.js` → `package.json` → docs →
   fixture → examples (generated against a staged fake HOME, then sanitized). Zero npm
   dependencies throughout. Preserve existing human material; confirm before overwriting a
   customized file.
3. **Plug in**: add a router row to the parent workspace's `CONTEXT.md` (or a pointer in its
   `AGENTS.md`/`CLAUDE.md`), per that workspace's conventions. No parent chain → the project
   stands alone. Report exactly what was changed.
4. **Verify**: syntax checks, both scripts green on real `~/.claude`, fixture flow (one HIGH
   per detector, exit 2), server-hardening curls (no-token/traversal/Host-spoof → 403),
   generated HTML contains no planted secret fragment, `reports/` still only `.gitkeep`.
