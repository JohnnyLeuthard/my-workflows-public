# command-reviewer — Build Spec

**Status**: Complete build contract as of 2026-07-12, including the D10/D11 hardening learned
from live failures on build day. `DECISIONS.md` alongside this file records the reasoning and
rejected alternatives.

**This folder is a standalone build seed, distributed separately from any built workspace**:
download `_design/`, drop it anywhere, and ask an agent to build it out — the Build &
Integration Protocol section at the end tells the builder where to build and how to
(optionally) register the workspace with a parent. It also serves as the restart path: if a
built workspace is corrupted, build fresh from here (preserving only `output/`). Built
workspaces never contain or reference this folder.

---

## Goal

Build `command-reviewer/`, a deliberately small ICM workspace that does one thing: **review
shell commands**. A user pastes any command (`brew`, `npm`, `bash`, `git`, `curl`, ...) and
gets a one-page review — every switch explained, a productivity score (1–5), a risk score
(1–5), and, when the command installs software, pros/cons and native alternatives.

Dual purpose: a genuinely useful tool, and a **teaching demonstration of a proper, minimal ICM
workflow** — every stage earns its existence, judgment lives in reference files, and the AI's
discretion is fenced on all sides (roughly the 60/30/10 split: infrastructure / orchestration /
AI inference).

## Hard Constraints (apply to everything)

- **Never execute the command under review.** The workspace analyzes; it does not run. This
  holds even if the user directly asks, and it is stated at Layer 0 *and* restated in the
  router, because every path passes through those files.
- **Plain markdown only, zero dependencies.** The workspace must work in any agent tool that
  can read files (Claude Code CLI/app/extension, Codex, Cursor, ...). No scripts ship in v1;
  any script ever added must follow the parent workspace's scripts rule (a `<name>.md` help
  file beside it).
- **Relative paths only.** Nothing inside the folder may reference an absolute path or assume
  a parent workspace exists — the folder must work wherever it is copied.
- **One command per review; one file per command.** Compound requests are handled one at a
  time, one output file each.
- **Chat is the delivery surface; `output/` is the archive** (D10). The user reads the review
  in the conversation; the file is the paper trail.

## Workspace Structure

```
command-reviewer/
├── CLAUDE.md            Layer 0 — the standard one-line pointer to AGENTS.md
├── AGENTS.md            Layer 0 — identity, layer table, ground rules
├── CONTEXT.md           Layer 1 — router (incl. the no-command-given behavior)
├── README.md            humans only — what it is, how to use it, tree map; agents never route through it
├── 01-intake/
│   └── AGENTS.md        Layer 2 — capture, classify, name the output file, hand off
├── 02-review/
│   └── AGENTS.md        Layer 2 — break down, score per rubric, fill template, write + display
├── reference/
│   ├── report-template.md   Layer 3 — exact shape of every review (human-editable)
│   └── scoring-rubric.md    Layer 3 — what the 1–5 scores mean + modifiers (human-editable)
└── output/
    └── README.md        Layer 4 — the review archive; one file per reviewed command
```

The seed itself (`_design/`) is **not** part of this structure — it is distributed separately
and no built file may reference it.

## The Front Door

- `CLAUDE.md`: the one-line pointer, never anything else (identity must not fork).
- `AGENTS.md` (Layer 0) answers only "where am I": what the workspace is, a layer table mapping
  files to Layers 0–4, and the ground rules — route first; one command per review; never
  execute (with the "even if directly asked" clause); stages own their steps.
- `CONTEXT.md` (Layer 1) routes and does nothing else. Required rows:

| Request | Route |
|---|---|
| Contains a command to review | `01-intake/AGENTS.md` |
| Contains **no** command (greeting, "review a command", entering the workspace) | Do not enter a stage. Reply: *"Review this command — paste it in."* Then wait |
| Asks what a score means / why a review scored that way | `reference/scoring-rubric.md` |
| Asks about a previously reviewed command | Look up in `output/` — no re-review unless asked |
| Asks to change how reviews look or score | Point the human at `reference/` — theirs to edit |

  Global constraints restated: router only routes; never execute; multiple commands processed
  one at a time.

## Stage 01 — Intake

Ends with a command in hand, understood well enough to review — nothing else. Must state
prerequisite (a command from the router; arrived without one → stop, back to the router),
reads, does, writes, per the ICM checklist. Steps:

1. Capture the command **verbatim**; quote it back in a code block; never "fix" typos.
2. Classify: tool family, and **does it install software** (drives the report's conditional
   sections).
3. Ambiguity check (placeholders, `$VAR`, pipes into unknowns): ask once, briefly.
4. Name the output file: full command, lowercase, kebab-case, flags included
   (`brew install wget` → `brew-install-wget.md`; `ls -la` → `ls-la.md`). Strip
   filename-hostile characters rather than encoding them.
5. Check `../output/` for that filename — **re-list the directory fresh at this moment; never
   trust a listing or memory from earlier in the conversation** (D11). Existing review → say
   so, ask re-review vs. show existing.

Writes nothing to disk (D2). Hand-off is an in-conversation block, then Stage 02:

```
Command:   brew install wget
Family:    brew (package manager)
Installs:  yes
Output:    output/brew-install-wget.md
Existing:  no
```

## Stage 02 — Review

Prerequisite: a completed intake hand-off block; missing → stop, back to Stage 01. Reads the
hand-off block plus both `reference/` files — **never score from gut feel**. Steps:

1. Break the command down: base command, every subcommand, every switch/option/argument. Unsure
   about a flag → say so in the report, don't guess.
2. Score productivity and risk 1–5 strictly per the rubric; each score cites the rubric line.
3. Fill the template top to bottom; `Installs: yes` → include the install-only sections,
   otherwise omit them entirely (never leave them empty).
4. Write the file to `../output/` under intake's filename.
5. Close out (D10, D11): **paste the full review into the conversation** so the user reads it
   without opening any file; **verify the file exists on disk before reporting done** (never
   claim completion from memory); state the path exactly as `output/<filename>.md` — never
   prefixed with the workspace folder's name (the prefix breaks the app's file links); one-line
   verdict.

Writes exactly one file per review.

## `reference/report-template.md`

Human-editable. Opens with usage rules (installs-only sections omitted when not applicable;
the naming rule — knowingly duplicated from intake step 4, see D4; an explicit "everything
below the divider is the template" sentence), then the template itself below a `---` divider:

- `# <command verbatim>` then a vitals table: Command / Family / Productivity n/5 / Risk n/5
- **Switches & Options** — table: each part of the command, plain-English explanation
- **What It Does** — 2–4 sentences, plain English
- **Scores Explained** — one line per score, citing the rubric
- **Pros & Cons** *(installs only)* — "Why you'd install it" / "Why you'd skip it" lines plus a
  pros/cons table
- **Native & Alternative Tools** *(installs only)* — table: tool, native?, how it compares
- **Verdict** — one sentence: use / use with care / avoid, and the single biggest reason

## `reference/scoring-rubric.md`

Human-editable. Both scores 1–5, defined so the same command scores the same in any session:

- **Productivity** (everyday value): 5 daily-driver → 4 frequently useful → 3 solid for a
  specific job → 2 niche → 1 rarely worth it.
- **Risk** (what can go wrong): 1 read-only → 2 writes only to safe expected places → 3 changes
  system state with a known undo → 4 hard to reverse / wide blast radius / sudo / system files
  → 5 destructive or dangerous by design (data loss, pipes remote code into a shell, disables
  protections).
- **Modifiers** (pre-decided judgment calls): `sudo` → risk floor 3; remote content piped into
  a shell → automatic risk 5; `--force`/`-f` → score as written but report must mention the
  safer form; torn between two scores → higher risk, lower productivity.

## `output/` and the READMEs

- `output/` is born with a `README.md` (not an `AGENTS.md` — nothing routes there for
  instructions): one file per command, named for the command; the archive; delete to forget.
- Root `README.md` is the human front door: what it is, how to use it (open the folder as a
  local session — not a chat attachment), a tree map in a fenced block, the flow summary. It
  must state that agents never route through it.

## Build & Integration Protocol *(for building from this seed)*

### Where to build

Build into a folder named `command-reviewer/` (or the name the human chooses) wherever the
human wants the workspace to live. The seed folder itself stays where it is — it is **never
moved into, shipped with, or referenced by** the built workspace.

### What to build

Everything in Workspace Structure, to the requirements above — a complete, from-scratch build.

### Restart (rebuilding over a corrupted or existing workspace)

Rebuilds are also from scratch — there is no partial-repair mode. Exactly one thing survives:
**`output/`** (the user's review archive) — never delete or overwrite files in it. If any
other existing file differs from spec, treat it as possible human customization (the
`reference/` files are explicitly human-editable): confirm with the human before overwriting,
and stop and ask before touching a workspace that appears healthy.

### Register with a parent (optional)

If the parent has a `CONTEXT.md` router **and the human confirms**: add a row routing "review
this command" requests to `command-reviewer/CLAUDE.md`, written in request language, following
the parent's row conventions. No parent chain → the workspace stands alone. Report exactly
what was changed, or that nothing was.

### Verify

- Every file in Workspace Structure exists; `CLAUDE.md` is the pointer; no placeholder text.
- Every route in `CONTEXT.md` resolves; every file a stage cites exists; no unreachable stage.
- Both stages state prerequisite + reads/does/writes and stop-and-report on missing
  prerequisites.
- Standing rules live in `reference/`, separate from stage logic; `output/` convention stated.
- Live test: a fresh session, paste `node -v` → intake block → review in chat → file verified
  in `output/node-v.md` with a correctly resolving link. If a previous `node-v.md` existed,
  delete it first and confirm the stale-memory guard holds.

## Out of Scope (v1)

- **Scripts** — including the filename-slug script that would demote naming from AI to
  infrastructure (parked in `NEXT-STEPS.md`).
- **Batch/index features** — a summary index of all reviews, multi-command batching beyond
  one-at-a-time.
- **A human-approval stage** (`Reviewed-by-human` flag or `03-approve/`) — parked; today the
  close-out invites review but nothing mandates it.
- **HTML or rendered output** — chat + markdown is the entire delivery stack.
- **Harness-specific machinery** (hooks, MCP, subagents) — must stay tool-agnostic.
