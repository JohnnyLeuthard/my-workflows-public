# Claude Manager — Build Spec

This is the build contract for `claude-manager`: enough to rebuild the whole project from
scratch, in this folder's parent, with no other instructions. Outcomes only — the reasoning
and rejected alternatives live in [DECISIONS.md](DECISIONS.md).

Supersedes the old root `SPEC.md` (removed 2026-07-11), which mirrored implementation detail
down to CSS class names and had drifted from the code. This spec stays at the level of
behavior and structure; the scripts themselves are the detail.

---

## Goal

Understand, audit, and manage everything in `~/.claude` — the folder where Claude Code stores
conversations, plans, file histories, settings, and session data. Three phases:

1. **Reference** (done) — README.md documents every folder/file in `~/.claude`: what it is,
   how sensitive it is, when it's safe to delete.
2. **Tools** (done except clean.js) — zero-dependency Node scripts: `scan.js` (dashboard),
   `audit.js` (security scan), `clean.js` (guided deletion — designed, not built).
3. **Visual interface** (planned) — interactive browse/manage UI. Not designed yet.

## Hard Constraints (apply to everything)

- **Zero npm dependencies.** `node scripts/<name>.js` must work on a fresh clone with nothing
  installed. `package.json` exists for metadata/scripts only (`private: true`, empty deps,
  `engines.node >= 16`).
- **Read-only by default.** `scan.js` and `audit.js` never modify `~/.claude`. Destructive
  work is `clean.js`'s job, and it must be dry-run by default with an explicit `--execute`.
- **Portable-drive workflow.** The repo lives on a cloud-synced portable drive used across
  machines. No machine-local state: no auto-memory, no writes outside the repo, and all
  persistent context in the repo's own markdown.
- **Nothing real in git.** `reports/` is gitignored (only `.gitkeep` tracked); `examples/`
  contains only sanitized fakes with an EXAMPLE banner; the fixture's credentials are
  obviously fake. `.gitignore` also blocks accidental copies of real `~/.claude` data
  (`*.jsonl`, `backups/`, `projects/`, etc.).

## Repository Structure

```
claude-manager/
├── CLAUDE.md                  ← project identity, workflow rules, structure map
├── CONTEXT.md                 ← navigation router for humans/agents
├── README.md                  ← THE reference: every ~/.claude folder documented
├── SCRIPTS.md                 ← user guide for the scripts: flags, examples, scenarios, exit codes
├── TASKS.md                   ← roadmap + progress checklist (always kept current)
├── SECURITY-REVIEW-PLAN.md    ← findings ledger from the 2026-07-11 security/design review
├── CONTRIBUTING.md, LICENSE   ← MIT
├── package.json               ← metadata only; `npm run scan` / `npm run audit`
├── _design/                   ← this folder: design record + build seed
├── scripts/
│   ├── lib/common.js          ← shared helpers (see below)
│   ├── scan.js                ← folder dashboard
│   ├── audit.js               ← security scanner
│   └── clean.js               ← [not built] guided deletion
├── examples/
│   ├── README.md
│   ├── example-dashboard.html ← sanitized static demo of scan.js output
│   ├── example-audit.html     ← sanitized static demo of audit.js output
│   └── fixtures/demo-shell-snapshot.sh  ← fake-credential fixture; exercises every audit detector
├── assets/                    ← infographic HTML/PNG/SVG/GIF for the README
└── reports/                   ← generated output (gitignored, only .gitkeep tracked)
```

## Shared Library — `scripts/lib/common.js`

Plain CommonJS, exports used by both scripts. One implementation of anything both need:

- `ANSI`, `setUseColor(bool)`, `c(key, text)`, `cb(key, text)` — terminal colors; color off
  unless stdout is a TTY and `--no-color` absent.
- `parseArgs()` → `{ showTerminal, showHtml, noColor }` from `--html`, `--html-only`,
  `--no-color`. `--html-only` implies HTML without terminal output.
- `escapeHtml(s)` — `& < > "`.
- `getClaudeDir()` — `os.homedir() + '/.claude'`.
- `openCommand()` / `openPath(target, opts)` — `open` (macOS) / `xdg-open` (elsewhere),
  always via `spawnSync` argument arrays, never a shell.
- `serveReport({ html, claudeDir, label, onRescan })` — the hardened local report server.

### Local report server — security model (do not weaken)

Serves a report on `127.0.0.1`, ephemeral port, 10-minute auto-shutdown. Any process on the
machine — including JS on any website in the user's browser — can reach that port, so:

1. **Per-run token**: 16 random bytes hex (`crypto.randomBytes`). Every route requires
   `?token=`; the token appears only in the URL printed/opened at startup and is injected
   into the served page as `window.__CM_TOKEN__` for its fetch calls. No token → 403,
   including on `/` (the report itself may name flagged files).
2. **Host-header check**: `Host` must be `127.0.0.1:<port>` or `localhost:<port>`, else 403
   (blocks DNS rebinding).
3. **Path containment** on `/open`: resolve, then `path.relative(claudeDir, resolved)` must
   not start with `..` or be absolute; reject paths starting with `-` (flag injection into
   the opener). Only then `openPath(resolved)`.

Routes: `GET /` (serve current HTML), `GET /open?path=` (open folder in Finder/Explorer),
`GET /rescan` (only if `onRescan` callback provided — regenerates the page, returns
`{ok:true}`). Anything else 404.

## `scripts/scan.js` — Folder Dashboard

Lists every directory in `~/.claude` with size, importance, description, freeable estimate,
pros/cons of deleting, docs links.

- **Flags**: none (terminal), `--html` (terminal + live server with working folder links and a
  Refresh button wired to `/rescan`), `--html-only` (static file to
  `reports/claude-dashboard.html`, folder links fall back to clipboard), `--no-color`.
- **Knowledge base**: `FOLDER_METADATA` — one entry per known folder (15 as of 2026-07:
  backups, cache, debug, downloads, file-history, ide, plans, plugins, projects, session-env,
  sessions, shell-snapshots, skills, telemetry, todos). Schema per entry: `importance`
  (CRITICAL/HIGH/MEDIUM/LOW), `description`, `spaceFreeable` (human string), `freeablePct`
  (0–1 — hand-estimated heuristic, and labeled as such wherever rendered), `proDelete`,
  `conDelete`, `docsUrl` (nullable), `usedBy` (tags: Claude Code, IDE extension, claude.ai,
  Coworker), `contextNote` (nullable).
- **Unknown folders**: anything on disk not in the metadata renders as `UNKNOWN` with a
  do-not-delete-without-research warning banner, and instructions to add it to the metadata.
- **Sizes**: pure-JS recursive apparent-size walk (`lstat`, skip symlinked dirs, swallow
  per-entry errors). No `du` — its semantics differ per platform.
- **Sorting**: importance rank, then size descending.
- **HTML dashboard**: summary bar (total / folder count / freeable "(heuristic)" / Refresh),
  unknown-folder banner, importance legend, responsive card grid (badge, clickable path via
  `/open`, size bar scaled to largest folder, description, used-by tags, freeable, pro/con
  lists, Docs + Google-search links), "Known Folder Reference" chip section showing
  present/absent known folders with a missing-folder status line, footer linking the most
  recent `audit-*.html` if one exists in `reports/`.

## `scripts/audit.js` — Security Scanner

Read-only scan of `~/.claude` for leaked secrets and risky config. Same flags as scan.js;
`--html-only` writes `reports/audit-YYYY-MM-DD.html`; `--html` serves via `serveReport`
(no rescan callback).

- **Finding schema**: `{ severity: HIGH|WARN|OK, target, file|null, pattern, preview, action }`.
  Every scanner returns at least one finding (OK "nothing to scan" / "no patterns matched"
  variants) so coverage is always visible.
- **Scanners** (`runAudit` returns `{ findings, targets }`; the report shows `targets.length`):
  1. `shell-snapshots/` — full secret-pattern sweep per file. HIGH per match.
  2. `session-env/` — sensitive env-var **names** only (`*_KEY`, `*_TOKEN`, `*_SECRET`,
     `*_PASSWORD`, `*_PASS`, `DATABASE_URL`, …), from JSON object keys or `KEY=value` lines.
     WARN per distinct name.
  3. `mcp-needs-auth-cache.json` — extract hostnames anywhere in the JSON; WARN for any not
     matching the known-safe suffix list (anthropic.com, claude.ai, github.com, google.com,
     linear.app, amazonaws.com, googleapis.com).
  4. Top-level `~/.claude/*.json` — secret-pattern sweep, **except** `.credentials.json`,
     which is reported present-but-not-scanned (it is *supposed* to hold tokens; scanning it
     is noise) with a keep-it-protected action.
  5. Config permissions — `.credentials.json` / `settings.json`: WARN with a `chmod 600`
     action if `mode & 0o077`. Skipped on Windows with an OK explaining why.
- **Secret patterns** — ordered most-specific first; matches de-duplicated per file by start
  offset (first pattern to claim an offset wins): Anthropic (`sk-ant-[\w-]{20,}`), OpenAI
  (`sk-(proj-)?[\w-]{20,}`), GitHub tokens (`gh[posur]_…`, `github_pat_…`), AWS (`AKIA…`),
  Google (`AIza…`), Slack (`xox[baprs]-…`), npm (`npm_…`), JWT (three `eyJ…` segments),
  private-key blocks (`-----BEGIN … PRIVATE KEY-----`), `Bearer <token>`, and named secrets
  (`*API_KEY|TOKEN|SECRET|PASSWORD|PASSWD[=:]value`). The Anthropic pattern must accept `-`
  and `_` in the key body — the original single `sk-[a-zA-Z0-9]{20,}` pattern could not match
  a real Anthropic key.
- **File safety**: before reading, stat; skip >5 MB (WARN "too large — inspect manually") and
  binary (NUL in first 512 bytes → WARN). Never read unbounded content into a regex.
- **Preview policy**: terminal shows first 6 chars + `***`, never full values. HTML reports
  show **no fragment at all** for HIGH matches ("value withheld from HTML reports…") because
  saved HTML can land in cloud-synced folders.
- **Disclosure**: both renderers always include (a) the disclaimer box — pattern matching is
  not exhaustive, clean ≠ secure, false positives/negatives, user owns due diligence — and
  (b) a "Not scanned" section listing `projects/`, `file-history/`, `backups/`,
  `todos/`/`plans/`, `history.jsonl` with one-line reasons.
- **Exit codes**: 2 if any HIGH, 1 if any WARN, 0 otherwise (via `process.exitCode`, so
  server mode still runs). Documented in SCRIPTS.md.

## `scripts/clean.js` — designed, not built

Dry-run by default; `--execute` required to delete; `--only-<category>`,
`--older-than-days N`, `--keep-count N`. Deletion log to `reports/clean-<date>.log`.
SCRIPTS.md documents the planned interface. Building it is a NEXT-STEPS item — design any
open questions through DECISIONS.md first.

## Examples & Fixture

- `examples/example-*.html` — static demos generated by actually running the scripts against
  a **staged fake HOME** (never real data), then post-processed: fake paths →
  `/Users/yourname`, interactive anchors unwrapped, `<script>` block removed, `— Example
  Report` title suffix, dark EXAMPLE banner injected. Regenerate whenever output shape
  changes.
- `examples/fixtures/demo-shell-snapshot.sh` — copy into `~/.claude/shell-snapshots/` to
  exercise **every** secret detector (one obviously-fake credential per pattern); header
  comment lists expected findings and explains the NAME=value double-report and the
  offset-dedup rule.

## Build & Integration Protocol *(for building from this seed)*

1. **Locate**: if this folder's parent is the project folder (even otherwise empty), build
   into the parent. If `_design/` was dropped bare into some workspace, create
   `claude-manager/` beside it, move `_design/` inside, build there.
2. **Build**: create the structure above. Order that works: `scripts/lib/common.js` →
   `scan.js` → `audit.js` → `package.json` → docs (README reference content, SCRIPTS.md,
   CLAUDE.md, CONTEXT.md, TASKS.md) → fixture → examples (generate via staged fake HOME).
   Preserve existing human material — an existing README knowledge base, TASKS history, or
   customized metadata beats regenerating; confirm before overwriting anything customized.
3. **Plug in**: if a parent workspace has a router (`CONTEXT.md`/`AGENTS.md`), add a row
   pointing here; otherwise the project stands alone. Report exactly what was changed.
4. **Verify** (all must pass):
   - `node --check` on all three JS files; `node scripts/scan.js` and `node scripts/audit.js`
     run green against the real `~/.claude`.
   - Fixture flow: stage a fake `$HOME` containing the fixture; expect one HIGH per detector
     (14 as of 2026-07-11) and exit code 2; clean HOME → exit 0.
   - Server hardening: with a stubbed opener, curl `/` without token → 403; `/open` with
     `..` traversal, sibling `-evil` prefix, or no token → forbidden; spoofed Host → 403;
     valid token + contained path → ok.
   - Generated audit HTML contains no fragment of any planted secret value.
   - `reports/` still contains only `.gitkeep` afterward; `git status` shows no real data.

## Out of Scope (v1)

- Scanning `projects/**/*.jsonl` transcripts (deferred `--deep` — see NEXT-STEPS.md).
- Phase 3 visual interface; multi-tool (non-Claude) folder auditing; scheduled/automated runs.
- Windows ACL checks (POSIX permission check is skipped there by design).
