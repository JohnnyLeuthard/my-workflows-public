# Research Lab — Build Spec

**Status**: Design locked (2026-07-05). All open questions were answered with the human and folded
into this spec; `DECISIONS.md` alongside this file records the reasoning and rejected
alternatives. Ready to build on the human's go.

**This folder is also a drop-in build seed**: copy `_design/` into any workspace and ask the agent
to build it out — the **Build & Integration Protocol** section at the end tells the builder where
to build and how to plug the lab into the surrounding workspace.

---

## Goal

Build a standalone **research and fact-checking lab**. A request goes in — research a question,
fact-check a list of claims, vet sources, or a mix — and a team of **specialists** gathers,
verifies, and delivers a cited, verdict-carrying **research packet**. The packet is the product:
the human drops it into whatever workspace needs it — a social-media post's input folder, a
debate-lab brief, a learning project. **Consumers pull; the lab never pushes** — this lab exists
precisely because research capability must serve every project without living inside any of them
(debate-lab decision D29).

The structure borrows deliberately from the debate lab: the front-door chain, the copy/rename
specialist template, the roster, per-job `STATUS.md`, teams (the committees pattern), and the
human checkpoint. But the run shape differs in two ways, stated up front:

1. **Phases are sequential with cross-reading.** Gatherers work in parallel; verifiers then
   deliberately read the gatherers' output — verification *is* the job, not contamination.
   There is no round-1 isolation rule here.
2. **The checkpoint verdicts are accept / dig-deeper / full reprocess.** Specialists do not
   argue with each other; there are no rebuttal rounds.

## Core Requirements

### 1. Per-job input folders, started from a template

Each job begins as a folder under `input/` — the staging area. The **job name is the folder
name** (`input/mfa-fatigue-claims/` → `output/mfa-fatigue-claims/`), lowercase with hyphens.
Input stays in `input/` while the job is live; at close it **moves** into `output/<job>/input/`
— the record carries its own request.

**`input/_template/`** is a ready-to-copy framework (underscore = scaffolding, never processed):

| File | Purpose |
|------|---------|
| `HOW-TO-START.md` | Steps: copy, rename, fill in, say "run this request" (deleted from the copy) |
| `request.md` | **Required** — what to research/verify, the request type (research / fact-check / source-vet / mixed), optional depth (quick / standard / deep), optional team or specialist selection |
| `claims.md` | Optional — numbered claims to fact-check, one per line, each ideally with where it came from |
| `links.md` | Optional — starting URLs, each with a note on why it matters |

Anything else can be added: documents to check, screenshots, draft text whose claims need
verifying. Empty optional files are "nothing supplied," never an error; only `request.md` must
have content.

### 2. Specialists — the template pattern

Specialists are workspace markdown, not harness agents — the same reasoning as debate-lab
personas (context loaded only when dispatched, portable, no machine config). Shared mechanics
live once in `reference/specialist-protocol.md`; every specialist's `AGENTS.md` is a thin
pointer to it and is never edited.

**Every specialist folder contains the same five files — you edit four:**

```
specialists/<specialist-name>/
├── AGENTS.md      ← identical in every specialist; NEVER edited (points to the shared protocol)
├── SPECIALIST.md  ← you write: identity, method, beat
├── SCOPE.md       ← you write: domains + expertise levels, blind spots
├── SOURCES.md     ← you write: this specialist's trusted + avoid lists (overrides global for itself)
└── CONFIG.md      ← you set: enabled + restrict-to-list (two lines)
```

`specialists/_template/` carries one extra file, `HOW-TO-CREATE.md`, deleted from every copy.
Full skeletons are in the **Specialist Template Scaffold** section below.

**Adding a specialist is three steps, no code**: copy `_template/` to
`specialists/<kebab-case-name>/`; fill in `SPECIALIST.md`, `SCOPE.md`, `SOURCES.md`, and
`CONFIG.md`; add a row to `reference/roster.md`. AI-assisted creation is a first-class path —
"add an academic-sources specialist" and the agent follows `HOW-TO-CREATE.md` itself.

**Expertise levels, not seniority clones.** `SCOPE.md` declares domains at
expert / working / aware / none — the same guardrail semantics as debate-lab: levels govern how
assertively findings are stated, and blind spots must be deferred on. There are no junior/senior
copies of a specialist; rigor per run comes from the request's **depth** setting
(requirement 6).

**The four starters** (shipped `enabled: true` as the tested set):

| Specialist | Beat |
|------------|------|
| `general-researcher` | Broad gathering on any topic: search strategy, reading, summarizing findings with citations |
| `fact-checker` | Claim-by-claim verification with verdicts and cited evidence |
| `data-checker` | Numbers: statistics, figures, base rates, cherry-picked ranges, misleading charts |
| `source-analyst` | The sources themselves: credibility, bias, primary vs secondary, conflicts of interest |

Suggested future additions (via the template, not built in v1): counter-researcher
(disconfirming evidence), academic-researcher, OSINT/news-researcher, and domain specialists
such as a security-researcher.

### 3. Source resolution — the precedence chain

Source lists are the heart of scope-of-work. Two levels exist: the lab-wide
`reference/sources.md` (a trusted list and an avoid list that apply to everyone) and each
specialist's own `SOURCES.md`. Resolution, per specialist:

1. **Specialist overrides global, for itself.** A source on the global avoid list but on this
   specialist's trusted list may be used *by this specialist* (and the reverse: globally
   trusted but on its avoid list → this specialist avoids it).
2. **Effective avoid list** = global avoid + own avoid − own trusted overrides.
3. **Effective trusted list** = global trusted + own trusted − own avoid overrides.
4. **`restrict-to-list: false`** (the default): prefer trusted sources, but roam freely beyond
   any list — the specialist has freedom to find sources — while never using anything on its
   effective avoid list.
5. **`restrict-to-list: true`**: the specialist uses **only its own `SOURCES.md` trusted list**
   — nothing else, not even the global trusted list. This is how a single-source specialist is
   built (the worked example in `HOW-TO-CREATE.md`: a `snopes-fact-checker` whose only trusted
   source is snopes.com).
6. Every finding and verdict cites its sources. A source that appears on no list is marked
   **unvetted** in the output so the source-analyst — or the human — can judge it.

### 4. Teams — named groups with a required `default`

`reference/teams.md` defines named groups of specialists, same semantics as debate-lab's
committees:

- A team named in `request.md` or the prompt **expands to its member list** as the per-request
  selection — shorthand, not a lock: additions and omissions apply on top ("fact-check team
  plus source-analyst"), several teams union.
- **The kill switch always wins**: a member with `enabled: false` is dropped and reported.
- **`default` is required**: when a request names no team and no specialists, the `default`
  team is the selection. It ships listing all four starters; edit that row to change the
  standing team. Missing file or malformed `default` row → fall back to all enabled
  specialists and report the misconfiguration.
- Members are kebab-case specialist folder names; `_template` may never be a member; a row
  naming a folder that does not exist makes that team misconfigured — reported, never guessed.

### 5. The run — dispatcher-owned phases

`dispatcher/AGENTS.md` (Layer 2) is the single entry point for every run — the project
`CONTEXT.md` routes "research this" / "fact-check this" requests here. The dispatcher writes
exactly one file per job — `output/<job>/STATUS.md` — and nothing else.

**Prerequisite checks (before any dispatch)**: `request.md` exists and is not empty; every
specialist's `CONFIG.md` parses (malformed → misconfigured, reported, excluded); if a team
sources the selection, `reference/teams.md` parses and every member folder exists; the resolved
team is not empty.

**Phase plan.** The dispatcher resolves the team (requirement 4), then plans phases from the
request type and records the plan in STATUS.md:

- **Phase 1 — gather** *(research and mixed requests)*: the gathering specialists on the team
  (general-researcher plus any domain specialists) work their beats **in parallel** — inline,
  one at a time, but independently — each writing `output/<job>/findings/<specialist>.md`:
  findings with citations, per the source rules (requirement 3) and the request's depth.
- **Phase 2 — verify**: the verifying specialists read the input **and phase-1 findings
  deliberately**. The fact-checker verifies every claim — from `claims.md` and extracted from
  phase-1 findings — writing the claim-verdict table to `output/<job>/verification/fact-checker.md`;
  the data-checker checks every number; the source-analyst vets the sources used and flags
  unvetted or weak ones.
- **Phase 3 — synthesize**: `synthesis/AGENTS.md` compiles everything into
  `output/<job>/packet-draft.md` per `reference/packet-format.md`, ending with the pre-seeded
  `## Human Review` block (requirement 7).

Fact-check-only requests skip phase 1; a source-vet-only request may run the source-analyst
alone. The dispatcher updates STATUS.md **after every specialist completes** (snapshot
refreshed, event appended), so an interruption loses at most one specialist's work.

**Resumption**: any session touching an existing job reads STATUS.md first, cross-checks it
against the files on disk (logged complete → stands; file exists but not logged → partial,
re-run; never dispatched → runs next), and continues. **On a missing or partial output —
auto-heal once, then stop**: re-run that specialist once; a second failure stops the run,
logs it, and reports to the human. Never a silent loop, never a synthesis over a hole.

### 6. Verdicts, depth, and settings

`reference/research-settings.md` pins the scales (all one-line editable):

- **Claim verdicts**: `confirmed` / `plausible` / `unsupported` / `contradicted` /
  `misleading-context` — every verdict requires cited evidence; "I couldn't check this" is
  `unsupported` with the reason, never a guess.
- **Depth** (per request, default `standard`): `quick` (best-effort sweep, 1–2 sources per
  claim), `standard` (corroboration expected, 2–3 independent sources for load-bearing
  claims), `deep` (exhaustive: primary sources where possible, disagreements chased down).
- **Dig-deeper soft cap**: default 3 loops per job; exceeding it needs the human's explicit
  say-so at the checkpoint.

**No weights.** A finding's force comes from its evidence and the specialist's declared
expertise level, surfaced as confidence notes — the credibility that matters here belongs to
*sources*, not personas.

### 7. Human checkpoint — a structured review block, then a verdict

Every run stops at `packet-draft.md`. Synthesis pre-seeds an empty **`## Human Review`** block
at the bottom of the draft, written so *any* person running the lab knows where to respond:

```markdown
## Human Review
*(Fill in any of the three sections below, then give a verdict: accept, dig deeper, or reprocess.)*

### Comments
<reactions to specific findings or verdicts — you can also drop `> COMMENT:` lines inline,
directly under the point being addressed>

### Direction
<overall steer for the next pass — "verify claim 3 harder", "find opposing views on X">

### New Information
<anything you're adding now: new links, new claims to check, corrections, files you just
dropped into input/<job>/>
```

Inline `> COMMENT:` lines and everything in the review block are the human's voice: they
**outrank the draft's framing**, and the next pass must explicitly address them. New
Information is first-class input — specialists treat it exactly like original request
material.

Verdicts, routed by the dispatcher:

- **Accept** → synthesis writes the final `output/<job>/packet.md`; the dispatcher moves
  `input/<job>/` into `output/<job>/input/` and the job is **closed** — never re-run under the
  same name (a follow-up is a new job, e.g. `mfa-fatigue-claims-v2`); new views of a closed
  job go to `output/<job>/reports/` on request and never touch `packet.md`.
- **Dig deeper** → the review block is routed to the named/affected specialists only; new
  findings and verification are **appended** as `findings/<specialist>-2.md` (never
  overwriting the first pass), and synthesis writes a revised draft with a fresh empty review
  block. Loops count against the soft cap (requirement 6).
- **Full reprocess** → the existing `findings/`, `verification/`, and draft move to
  `output/<job>/superseded/<date>/` (kept, never deleted); the run restarts from phase 1 with
  the review block carried forward as input.

### 8. The research packet — the deliverable

`reference/packet-format.md` pins the format of `packet-draft.md` / `packet.md`, in this order:

1. **Summary** — what was asked, what was found, in a few sentences.
2. **Findings** — by topic/question, each finding cited.
3. **Claim-Verdict Table** — claim | verdict | evidence (one line) | sources.
4. **Numbers Check** — every figure examined, verdict and source.
5. **Sources** — every source used, with trust status (trusted / unvetted / flagged), which
   list it came from, and any specialist-override notes (e.g. "globally avoided; trusted by
   snopes-fact-checker per its SOURCES.md").
6. **Open Questions & Gaps** — what couldn't be verified or reached, and why.
7. **How This Research Ran** — appendix from the STATUS.md log: team, phases run, depth,
   restricted specialists, dig-deeper loops, dates, and tooling limits hit (requirement 9).

Packets are **self-explaining** because they travel: a reader in another workspace (or another
person entirely) must be able to judge the packet without opening this lab.

### 9. Consumers pull — and tooling honesty

- The lab never pushes into other projects. The human carries `packet.md` (or points a
  consumer at it): drop it into a social-media `input/<post>/`, a debate-lab `input/<job>/`,
  anywhere. The connection lives in the consumer's hands, never in this lab's configuration.
- **Research quality depends on the tools available to the running agent** (web search, web
  fetch). The lab states this plainly instead of degrading silently: with no web access it
  works from supplied material only, and in every case the packet's "How This Research Ran"
  appendix records what could and could not be reached.

### 10. Conventions carried over

- Front-door chain: `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` router; humans get `HOW-TO-USE.md`.
- Per-job outputs under `output/<job>/`, mirroring the input folder name.
- `reference/roster.md` — the library index, one row per specialist, documents-not-controls.
- Reference files are standing and human-editable; behavior changes are made by editing
  reference/settings files, never by rewriting stage logic.
- Prerequisite checks before every phase; auto-heal once, then stop and report.
- State lives on disk: any fresh session resumes a job from its STATUS.md.
- `_design/` is the design record and build seed; it is not part of any run.

### 11. `HOW-TO-USE.md` — the human's manual

Ships at the lab root, plain language, never routed through by agents. Four sections, in order:

1. **What this is** — a request goes in, specialists gather and verify, you review a draft
   packet and steer, the final packet is yours to drop into any other project. Name the key
   ideas (specialists, source lists, restrict-to-list, teams, depth, the review block) in
   everyday words.
2. **Your first run** — point at the two shipped samples with the exact thing to say
   ("run `input/sample-research-…`").
3. **Step by step** — copy `input/_template/`, what each file is for, request types and depth,
   what happens during the phases, exactly how to fill in the `## Human Review` block and give
   one of the three verdicts, where `packet.md` lands and how to hand it to another workspace.
4. **Quick recipes** — add a specialist (`specialists/_template/HOW-TO-CREATE.md`); build a
   restricted specialist (the snopes-fact-checker example); edit the global or a specialist's
   source lists; define a team or change the `default` team; resume an interrupted job; get a
   new view of a closed job (`output/<job>/reports/`).

Kept-current rule: any design change that alters how the human interacts with the lab must
update `HOW-TO-USE.md` in the same change.

### 12. Shipped samples

Two prefilled requests, one per main request type, so first runs test the machine:

- `input/sample-research-passkeys/` — **research**: "what are passkeys and are they actually
  replacing passwords?" — `request.md` (type: research, depth: standard) plus a `links.md`
  with two or three starting URLs. *(Topic illustrative — the builder may substitute another
  evergreen tech topic.)*
- `input/sample-factcheck-passwords/` — **fact-check**: a `claims.md` of 4–6 checkable
  security claims of mixed truthfulness (e.g. "the most common password is still 123456",
  "forcing 90-day password rotation improves security") plus a `request.md` (type:
  fact-check, depth: standard).

## Specialist Template Scaffold

Verbatim skeletons — where the builder creates these files, copy them; `<angle brackets>` are
guidance kept in the shipped files.

### `reference/specialist-protocol.md` — the shared mechanics (one copy)

Defines, for every specialist:

- **Read order**: my `SPECIALIST.md` → my `SCOPE.md` → my `SOURCES.md` + the global
  `reference/sources.md` (resolve per the precedence chain, requirement 3) → the job's input
  (and, in phase 2, the phase-1 findings).
- **Prerequisite check**: my required inputs exist (phase 1: `request.md`; phase 2: the
  phase-1 findings logged complete, or claims.md for a fact-check-only run; dig-deeper pass:
  the reviewed draft with the `## Human Review` block). Missing → stop and report, write
  nothing.
- **Source discipline**: apply the precedence chain before searching; cite everything; mark
  unvetted sources; if `restrict-to-list: true`, my own trusted list is the whole world.
- **Output structure per phase**: findings files (topic → finding → citations → confidence
  note), verification files (the claim-verdict table per `research-settings.md` verdicts).
- **Guardrails by expertise level**: expert — assert; working — contribute, flag uncertainty;
  aware — perspective only; none — defer. Never invent facts, never guess a verdict.
- **Human direction**: `> COMMENT:` lines and the `## Human Review` block outrank the draft's
  framing; any comment aimed at me must be explicitly addressed in my next output.

### The template files

**`AGENTS.md`** — identical in every specialist, never edited:

```markdown
# Specialist: <name>

1. Read `../../reference/specialist-protocol.md` — it defines how all specialists work.
2. Read `SPECIALIST.md`, `SCOPE.md`, and `SOURCES.md` in this folder — they define who I am
   and what sources I use.
3. Check `CONFIG.md` — if `enabled: false`, stop and report this specialist is disabled.
4. Follow the protocol.
```

**`SPECIALIST.md`** — the identity:

```markdown
# <Specialist Name>

## Who I Am
<one paragraph: role, background, what kind of work this specialist does>

## My Method
<how I work: e.g. start from primary sources, triangulate across independent outlets,
always check the date and the original context>

## My Beat
<what kinds of requests or claims I take; what I leave to other specialists>
```

**`SCOPE.md`** — the guardrails:

```markdown
# Scope: <Specialist Name>

| Domain | Level | Notes |
|--------|-------|-------|
| <domain> | expert | <what specifically> |
| <domain> | working | |
| <domain> | aware | |

Levels: expert / working / aware / none — behavior per level is defined in the specialist
protocol.

## Blind Spots
<things this specialist must explicitly defer on, even if asked directly>
```

**`SOURCES.md`** — the source lists (overrides global for this specialist):

```markdown
# Sources: <Specialist Name>

Entries here override `reference/sources.md` for this specialist only (see the precedence
chain in the spec/protocol). Leave sections empty to just inherit the global lists.

## Trusted
| Source | Why / what for |
|--------|----------------|
| <url or publication> | <what it's authoritative on> |

## Avoid
| Source | Why |
|--------|-----|
| <url or publication> | <reason> |
```

**`CONFIG.md`** — exactly two lines, machine-parsed on every run. The template ships disabled:

```
enabled: false
restrict-to-list: false
```

Only recognized values: lowercase keys, `true`/`false`. Anything else and the dispatcher
treats the specialist as misconfigured and reports it rather than guessing.
`restrict-to-list: true` confines the specialist to its own `SOURCES.md` Trusted table —
nothing else.

**`HOW-TO-CREATE.md`** — the build rules (deleted from copies). Opens with the rule: *your new
folder has six files — you will edit four, leave one untouched, and delete one.* Steps:

1. Copy `specialists/_template/` to `specialists/<kebab-case-name>/`.
2. **Edit** `SPECIALIST.md` — identity, method, beat.
3. **Edit** `SCOPE.md` — domains with levels, blind spots.
4. **Edit** `SOURCES.md` — trusted/avoid lists (empty sections inherit the global lists).
5. **Edit** `CONFIG.md` — keep `enabled: false` until tested; set `restrict-to-list`.
6. **Do not touch** `AGENTS.md`; **delete** `HOW-TO-CREATE.md` from your copy.
7. Add a row to `reference/roster.md`.
8. Solo-test on a small request (the one thing that can run a disabled specialist), then flip
   `enabled: true`.

**Worked example — a restricted, single-source specialist**: `snopes-fact-checker` —
`SPECIALIST.md` says it checks claims only against Snopes' published fact-checks;
`SOURCES.md` Trusted table has exactly one row (`https://www.snopes.com`); `CONFIG.md` is
`enabled: true` / `restrict-to-list: true`. Other specialists may still use Snopes among many
sources; this one uses nothing else. Use this pattern for any authority you want consulted in
isolation.

### `output/<job>/STATUS.md`

```markdown
# STATUS — <job>

## Snapshot
- **Request type**: <research | fact-check | source-vet | mixed>   **Depth**: <quick | standard | deep>
- **Team source**: <team name(s) + adjustments | "default team" | "explicit list">
- **Team**: <specialist>, <specialist>, …   **Dropped**: <specialist> — <kill switch | omitted | misconfigured>
- **Phase plan**: <e.g. gather → verify → synthesize>   **Now**: <phase / awaiting review / closed>
- **Dig-deeper loops**: <n> of <cap>

## Event Log
<!-- append-only, one line per event, never rewrite -->
- <date> — team resolved (source: …): …
- <date> — <specialist> complete (phase 1)
- <date> — packet draft written; awaiting human review
- <date> — verdict: <accept | dig deeper (targets: …) | reprocess (reason: …)>
```

## Proposed Folder Structure

```
research-lab/
├── CLAUDE.md                     ← pointer to AGENTS.md
├── AGENTS.md                     ← workspace identity (Layer 0)
├── CONTEXT.md                    ← router (Layer 1): run requests → dispatcher/; new specialists → _template/
├── HOW-TO-USE.md                 ← the human's manual (people read it; agents never route through it)
│
├── dispatcher/AGENTS.md          ← Layer 2, entry point: team resolution, phase plan, checkpoint routing
├── synthesis/AGENTS.md           ← Layer 2: compiles the packet, pre-seeds the Human Review block
│
├── specialists/                  ← Layer 2, the workers
│   ├── _template/                ← ready-to-copy skeleton (never runs)
│   │   ├── HOW-TO-CREATE.md      ← build rules + the snopes-fact-checker worked example
│   │   ├── AGENTS.md             ← thin pointer to reference/specialist-protocol.md (never edited)
│   │   ├── SPECIALIST.md         ← identity, method, beat
│   │   ├── SCOPE.md              ← domains + expertise levels, blind spots
│   │   ├── SOURCES.md            ← trusted/avoid lists (override global for this specialist)
│   │   └── CONFIG.md             ← enabled + restrict-to-list
│   ├── general-researcher/       ← each starter: same five files (no HOW-TO)
│   ├── fact-checker/
│   ├── data-checker/
│   └── source-analyst/
│
├── reference/                    ← Layer 3, standing rules (all human-editable)
│   ├── roster.md                 ← library index: one row per specialist
│   ├── teams.md                  ← named specialist groups; `default` row = the standing team
│   ├── specialist-protocol.md    ← shared mechanics (read order, source discipline, output structures)
│   ├── sources.md                ← lab-wide trusted + avoid lists
│   ├── packet-format.md          ← the deliverable format (requirement 8)
│   └── research-settings.md      ← verdict scale, depth definitions, dig-deeper cap
│
├── input/                        ← Layer 4: staging — one folder per LIVE job (moved into the record at close)
│   ├── _template/                ← copy to start a job (requirement 1)
│   ├── sample-research-passkeys/     ← shipped sample: research request
│   └── sample-factcheck-passwords/   ← shipped sample: fact-check request
│
├── output/                       ← Layer 4: one folder per job = the permanent record
│   └── <job>/
│       ├── STATUS.md             ← dispatcher-owned: snapshot + event log (read first to resume)
│       ├── findings/<specialist>.md, <specialist>-2.md …   ← phase 1 (and dig-deeper passes)
│       ├── verification/<specialist>.md …                  ← phase 2
│       ├── packet-draft.md       ← + the Human Review block at each checkpoint
│       ├── packet.md             ← final deliverable (once written, the job is closed)
│       ├── superseded/<date>/    ← displaced work after a reprocess (kept, never deleted)
│       ├── input/                ← the request, archived here at close
│       └── reports/              ← derived views of a closed job, on request
└── _design/                      ← this seed (CLAUDE/AGENTS/CONTEXT + SPEC.md + DECISIONS.md); not part of the run
```

## Flow Summary

1. Human copies `input/_template/` to `input/<job>/`, fills in `request.md` (plus `claims.md`,
   `links.md`, material as needed) and says **"run this request"**.
2. The router sends the run to the **dispatcher**: prerequisite checks, team resolution (named
   team/specialists, else the `default` team; kill switch wins; misconfiguration reported),
   phase plan from the request type — all recorded in `STATUS.md`.
3. **Gather** (research/mixed): each gathering specialist works its beat per the source
   precedence chain and depth, writing `findings/<specialist>.md`. STATUS.md updated after
   each.
4. **Verify**: fact-checker builds the claim-verdict table over `claims.md` + the findings;
   data-checker checks the numbers; source-analyst vets and flags sources.
5. **Synthesize**: `packet-draft.md` per the packet format, ending with the empty
   `## Human Review` block. The run stops.
6. **Checkpoint**: the human fills in Comments / Direction / New Information (and/or inline
   `> COMMENT:` lines), then gives a verdict — **accept** (→ 7), **dig deeper** (targeted
   specialists run again with the review block as first-class input; revised draft; → 6), or
   **full reprocess** (work superseded-archived; → 3).
7. Final `packet.md` written; input archived into the job folder; job closed. The human drops
   the packet wherever it's needed — a social-media post's input folder, a debate-lab brief,
   anywhere.

## Build & Integration Protocol *(for building from this seed)*

Follow this when asked to build (or rebuild) the lab from `_design/`.

### Where to build

1. **`_design/` sits inside a project folder** (its parent is the lab folder itself — empty,
   partial, or complete): build into the parent. Missing pieces are created per this spec;
   existing human material is kept per the preservation rule below. Confirm before overwriting
   any machine file that differs from what the spec describes.
2. **`_design/` was dropped directly into a workspace root**: create `research-lab/` beside it
   (the human may name it otherwise), **move `_design/` inside it**, then build as in case 1.

### What to build

Everything in the Proposed Folder Structure: the front-door chain, `HOW-TO-USE.md` (per
requirement 11), `dispatcher/AGENTS.md`, `synthesis/AGENTS.md`, the six `reference/` files
(`teams.md` shipping with the `default` row listing the four starters; `sources.md` shipping
with a few illustrative entries and clear section headers), `specialists/_template/` (per the
scaffold, including `HOW-TO-CREATE.md` with the snopes-fact-checker example), the four starter
specialists (five files each, registered in `reference/roster.md`, shipped `enabled: true` /
`restrict-to-list: false`), `input/_template/`, the two shipped samples (requirement 12), and
an empty `output/`.

Where this spec gives verbatim scaffolds, copy them; where it gives requirements (stage
behavior, reference contents, sample text), write files that satisfy them.

### Preservation rule (rebuilds)

A rebuild restores machine files but never clobbers what the human made: specialists the human
added or edited (including their `SOURCES.md` lists), edited source/team files, real
`input/<job>/` folders, and **everything under `output/`** — job folders are the permanent
record and are never touched. Any machine file that exists but was customized gets a
confirmation before overwrite.

### Plugging into the parent workspace

1. **Parent has a `CONTEXT.md` router**: add or update the routing row (e.g. *"Research
   requests, fact-checking, source vetting → research-lab/CLAUDE.md"*), following that
   router's own format. Replace any row still pointing at this `_design/` as "not built yet".
2. **Parent has `CLAUDE.md`/`AGENTS.md` but no router**: add a short pointer in the parent
   `AGENTS.md`, matching its style.
3. **No parent chain**: the lab stands alone; offer a minimal root chain, don't create one
   unasked.

Always report exactly which parent files were changed (or that none needed changing).

### Verify

Structural, not end-to-end — a run cannot complete unattended because it ends at the human
checkpoint:

- Every specialist folder has exactly the five files; `_template/` additionally has
  `HOW-TO-CREATE.md`.
- Every `CONFIG.md` parses per the pinned two-key format.
- `reference/roster.md` rows match the specialist folders one-to-one (excluding `_template/`).
- `reference/teams.md` parses, contains a `default` row, and every member references an
  existing specialist folder (never `_template`).
- `reference/sources.md` has Trusted and Avoid sections.
- Both sample inputs contain a `request.md`; the fact-check sample also has `claims.md`.
- `HOW-TO-USE.md` exists with the four sections in order and matches the built lab (folder
  names, the review block, the three verdicts).
- The parent router row (if any) resolves.

Then tell the human the lab is ready and offer a first run on a shipped sample — do not
auto-run one.

## Out of Scope (for v1)

- **Additional specialists** — counter-researcher, academic-researcher, OSINT/news-researcher,
  and domain specialists (e.g. security-researcher) are suggested future adds via the
  template, not built.
- **Scheduled or recurring monitoring runs** ("watch this topic") — every run is
  human-initiated.
- **Auto-delivery into other workspaces** — consumers pull (requirement 9); the human carries
  the packet.
- **Source-list auto-maintenance** — `sources.md` files are human-edited. The source-analyst
  may *recommend* list additions or removals inside a packet; it never applies them.
