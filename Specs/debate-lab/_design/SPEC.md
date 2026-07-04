# Debate Lab — Build Spec

**Status**: Design locked (2026-07-03). All open questions were answered with the human and folded
into this spec — sections marked *(decided 2026-07-03)* record the outcomes; `DECISIONS.md`
alongside this file records the reasoning and rejected alternatives. Ready to build on the human's go.

**This folder is also a drop-in build seed**: copy `_design/` into any workspace and ask the agent
to build it out — the **Build & Integration Protocol** section at the end tells the builder where
to build and how to plug the lab into the surrounding workspace.

---

## Goal

Build a new ICM workspace, `debate-lab/`, that debates an issue from multiple
perspectives. One input fans out to several independent **personas**, each of which
interprets the same material through its own lens. A **master (synthesis) stage**
then reads every persona's output and produces a full report. After each round the
process stops at a **human checkpoint**, where the master's rebuttal recommendation
can be accepted, adjusted, or sent back for another debate round. A **moderator**
stage owns the run itself — panel resolution, dispatch, checkpoint routing — so the
process logic lives in a file like everything else.

This is the fan-out/fan-in pattern, in contrast to the teaching lab's pipeline
pattern. Same building blocks: folders, markdown instructions, router, references,
per-job outputs.

## Core Requirements

### 1. Personas (fan-out)
- One folder per persona under `personas/`, containing a small set of markdown files
  (see requirement 2) that define how it acts, how it treats the data, and how it
  interprets the issue from its perspective.
- **Expertise guardrails**: every persona declares what it is an expert on and at
  what skill level. In a debate it argues confidently only inside its expert
  domains; outside them it may still comment from its perspective (values,
  judgment, experience) but must label its confidence and must not invent facts.
  This is what lets a CyberArk L3 engineer and a stoic philosopher join the same
  debate usefully — each knows which parts of the question are theirs.
- Every persona reads the **same input**. In round 1, personas must NOT read each
  other's outputs — isolation prevents anchoring and produces real disagreement.
- Every persona writes its take in a **common output structure** so the master can
  compare like with like — defined once in `reference/persona-protocol.md` (see the
  Persona Template Scaffold section): position, strongest arguments, biggest risk,
  what would change my mind, question for the other side, confidence notes.
- The persona range is deliberately wide — technical roles, philosophical voices,
  ordinary perspectives — because the debate type is wide (see requirement 3).

### 2. The persona template folder — copy, rename, register
- `personas/_template/` is a complete, ready-to-copy persona skeleton containing
  ALL the files a persona needs, plus the rules for building one:

  | File | Purpose |
  |------|---------|
  | `HOW-TO-CREATE.md` | Step-by-step rules for making a new persona (this file is deleted from the copy) |
  | `AGENTS.md` | Thin pointer to `reference/persona-protocol.md` (the shared mechanics) — identical in every persona, rarely edited |
  | `PERSONA.md` | Identity: who this is, voice, worldview, how it approaches problems |
  | `EXPERTISE.md` | Domains with skill levels (expert / working / aware / none) — the guardrails |
  | `CONFIG.md` | Operational state: `enabled: true/false` kill switch + `weight: 1–5` credibility |

  Full skeletons for each file are in the **Persona Template Scaffold** section below.

- **Adding a persona is three steps, no code**:
  1. Copy `personas/_template/` to `personas/<new-name>/` and rename.
  2. Fill in `PERSONA.md`, `EXPERTISE.md`, and `CONFIG.md` — the only three files
     you ever edit (`AGENTS.md` stays untouched; delete `HOW-TO-CREATE.md`).
  3. Add a row to `reference/roster.md`.
- **AI-assisted creation is a first-class path**: the human can simply say "add a
  Linux admin persona" and the agent follows `HOW-TO-CREATE.md` itself — same
  three steps, human reviews the result.
- The underscore in `_template/` marks it as scaffolding: the roster never lists
  it and it never participates in a debate.

### 3. Debate types — the lab is question-agnostic
The input can be any of:
- **Technical troubleshooting** (e.g. a CyberArk credential-retrieval failure —
  debated by Windows admin, Linux admin, CyberArk L3, network engineer)
- **Moral / ethical questions** (the stoic and other value-centered personas carry
  these; technical personas contribute constraints and consequences)
- **General questions and decisions**
- **Research questions** (personas as competing schools of thought)

The persona mechanics do not change per type — the expertise guardrails
automatically shift who speaks with authority and who speaks with perspective.

### 4. Persona selection — three control layers *(decided 2026-07-03)*

Default is **all personas on**, controlled through three layers, strongest first:

| Layer | Where | Purpose |
|-------|-------|---------|
| 1. Kill switch | `CONFIG.md` in each persona folder: `enabled: true/false` | Hard off for debates. A disabled persona never joins panel resolution, no matter what a debate requests. One exception: an explicit human request to **solo-test** a named persona (HOW-TO-CREATE step 8) may run it alone — it still cannot join a debate. |
| 2. Per-debate selection | The debate's input brief (or the spoken prompt) | Name the panel or omit personas for this debate only ("omit the stoic", "just cyberark-l3 and network-engineer"). |
| 3. Registry | `reference/roster.md` | The library index — every persona gets a row when created. Documents what exists; does not control runs. |

`CONFIG.md` also carries a **weight** (1–5) — the persona's credibility in
synthesis. An L1 engineer might carry weight 2 where an L3 carries 5; the master
factors weight when adjudicating conflicts (a high-weight expert's confident
claim inside its domain outranks a low-weight one), but weight is a signal, not
a veto — a good argument still beats rank.

### 5. Moderator — owns the run loop *(decided 2026-07-03)*

`moderator/AGENTS.md` (Layer 2) is the single entry point for every debate run —
the project `CONTEXT.md` routes "debate this" requests here. The moderator:

- **Resolves the panel**: start from all personas, drop any with `enabled: false`
  in `CONFIG.md`, then apply the brief/prompt selections and omissions (the three
  layers of requirement 4). Stops and reports if the resulting panel is empty.
- **Dispatches the fan-out** — inline, one persona at a time, fresh read per
  persona — and enforces round-1 isolation (no cross-reading).
- **Hands off to synthesis** once every panel persona has written its round file.
- **Routes the human's checkpoint verdict**: accept → master writes the final
  report; rebuttal → dispatch the confirmed panel into the next round; reprocess
  → back to round 1.

The moderator maintains exactly one file per debate — `output/<job>/STATUS.md`
*(decided 2026-07-03)* — and writes nothing else. The file has two parts:

- **Snapshot** (top, overwritten on every update): current round, the resolved
  panel with weights, who was dropped and why (kill switch vs omission),
  **per-persona completion for the round in progress** (done / not yet run), and
  what is awaited (e.g. "round 1 complete — awaiting human checkpoint").
- **Event log** (below, append-only, one line per event): dispatches, each
  persona's completion, round completions, checkpoint verdicts, interruptions
  noticed on resume. The log doubles as raw material for the report's provenance
  and position-evolution sections, and answers "how did we get here" after days
  away.

The moderator updates STATUS.md **after every persona completes** — not just at
round transitions — precisely so an interruption mid-round loses at most one
persona's work.

**Resumption rule** *(covers planned pauses AND interruptions — token exhaustion,
manual abort, crashed session)*: any session touching an existing job reads
`STATUS.md` first, then cross-checks it against the files actually on disk:

- A persona logged **complete** is never re-run; its file stands.
- A persona file that exists but is **not logged complete** is treated as
  partial — its file is overwritten and that persona re-runs.
- Personas never dispatched simply run next.

The debate then continues from that point, whenever the human asks — mid-round,
mid-debate, days later. State lives in the files, not in any session's memory.

This separates three clean roles: the **moderator** runs the debate, the
**master** judges the content, the **personas** argue. The master stays a pure
synthesizer.

### 6. Master / synthesis (fan-in)
- Reads every persona output for the current round.
- After each round, writes an **assessment** (`round-N/master-assessment.md`):
  per persona — its position, where it clashes with the others, and why; plus a
  recommendation on whether a rebuttal round is warranted and which personas
  should participate. The assessment ends with an empty `## Human Direction`
  section, pre-seeded for the checkpoint.
- Factors persona **weights** from `CONFIG.md` when adjudicating conflicts:
  a high-weight expert speaking inside its domain outranks a low-weight one,
  but weight is a signal, not a veto.
- After the final round, produces `report.md` per `reference/report-format.md`.
  The format must force disagreement to the surface: points of agreement, points
  of conflict, what would change each persona's mind — plus a **position
  evolution** section: who changed between rounds, who held firm, and why.
- The report closes with a **"How this debate ran" appendix** *(decided
  2026-07-03)*: the panel with weights, rounds run, personas who sat out and why
  (disabled vs omitted), and dates — drawn from the `STATUS.md` event log, so the
  report is self-explaining to a reader who never opens the rest of the folder.
  Findings lead; mechanics close.
- The master holds no position of its own — it judges and organizes the others.

### 7. Re-debate loop with human checkpoint *(decided 2026-07-03)*

After each round, the process stops at a **human checkpoint**:

1. The master writes its assessment (see requirement 6), including a rebuttal
   recommendation and proposed participant list.
2. The human reviews the persona outputs and the master's assessment, and adds
   comments **directly into the assessment file** using the marked convention
   *(decided 2026-07-03)*: `> COMMENT:` blockquote lines dropped directly under
   the specific point being addressed, and/or overall steer written into the
   pre-seeded `## Human Direction` section at the bottom. Either or both, per
   checkpoint.
3. The human decides: accept the report as-is, or order a rebuttal round —
   confirming, adding, or removing personas from the master's proposed panel.
   The human can also order a full reprocess (back to round 1) if a result is
   fundamentally off. **On a reprocess, the existing round folders are moved to
   `output/<job>/superseded/<date>/`** — never deleted, the record keeps
   everything — and the event log records the verdict and the human's reason.

Rebuttal mechanics:
- **What rebuttal personas read**: the master's assessment *with the human's
  comments in it*, plus their own previous round file and the original debate
  input — never each other's full outputs. Focused, cheap, and the human's
  steer is baked into the round. The marked lines (`> COMMENT:` and
  `## Human Direction`) are the human's voice: they **outrank the master's
  framing**, and a persona must explicitly address any comment aimed at it.
- **Position accountability**: in a rebuttal, each persona must explicitly state
  whether it changed or held its position, and why.
- **Personas left out of a rebuttal keep their prior positions.** They are
  recorded in the position-evolution section as "held (did not re-debate)" —
  the final report synthesizes across ALL panel personas' latest positions, not
  just the rebuttal participants.
- **Backstop**: max 2 rounds total (initial + 1 rebuttal). At the final allowed
  round's checkpoint, rebuttal is off the table — the verdict is accept or full
  reprocess — and the master writes the final report with remaining conflicts
  documented as unresolved. The limit lives in `reference/debate-settings.md`
  and can be raised by editing one line.

### 8. Per-debate input folders *(decided 2026-07-03)*

Each debate gets its own **folder** under `input/` (not a single file), so one
debate can carry multiple context files:

```
input/<job>/
├── brief.md        ← the question/issue + any persona selection or omissions (required)
├── logs/           ← log files, error dumps (optional)
├── links.md        ← related URLs, tickets, Confluence pages (optional)
└── …               ← anything else relevant
```

- The job name comes from the folder name (`input/ccp-outage/` → `output/ccp-outage/`).
- `brief.md` is the only required file; personas read the whole folder.
- Persona selection/omission for the debate can be stated in `brief.md` or in the
  spoken prompt (see requirement 4, layer 2).

**Shipped samples** *(decided 2026-07-03)* — the lab ships with two prefilled
debates, so the first runs test the machine rather than the human's brief-writing,
and the two debate types are both demonstrated from day one:

- `input/sample-ccp-failure/` — **technical troubleshooting**: an app
  intermittently fails to retrieve credentials via CCP; Windows hosts are fine,
  Linux hosts are failing. Contains `brief.md`, a fake log snippet in `logs/`,
  and `links.md`. Exercises the four technical personas hard, with the stoic on
  risk and urgency.
- `input/sample-account-maturity/` — **moral/policy question**: should service
  accounts that miss maturity deadlines be auto-disabled, or should owners keep
  being chased? Contains `brief.md` only. The stoic takes a lead role; the
  technical personas contribute constraints and consequences.

### 9. Conventions carried over from the teaching lab
- Front-door chain: `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` router.
- Per-job outputs under `output/<job>/`, mirroring the input folder name.
- Rounds live in subfolders: `output/<job>/round-1/<persona>.md` plus
  `round-1/master-assessment.md`, with the final `report.md` at the job root.
- Reference material is standing and human-editable; behavior changes are made by
  editing reference files, never by rewriting stage logic.
- Workspace root `CONTEXT.md` gets a router row for the new project.

### 10. Prerequisite checks and failure handling *(decided 2026-07-03)*

Every stage verifies its inputs before working — the teaching lab's "if the
upstream file is missing, go back" rule, adapted to the fan-out shape:

| Stage | Checks before working |
|-------|----------------------|
| Moderator | `input/<job>/brief.md` exists and is not empty, before any dispatch; resolved panel is not empty (requirement 5); every persona's `CONFIG.md` parses (requirement on malformed → misconfigured, not guessed) |
| Persona | Round 1: the debate brief exists. Rebuttal: the commented master assessment exists. If missing — stop and report, write nothing |
| Master | Every panel persona is logged complete in `STATUS.md` AND its round file exists, before assessing; the checkpoint-commented assessment exists before dispatching a rebuttal; assessments exist before the final report |

**On failure — auto-heal once, then stop.** A missing or partial persona output
is the same situation as an interruption, so the moderator applies the same
recovery: re-run that persona once. If the check fails again, stop, append the
failure to the `STATUS.md` event log, and report to the human. Self-healing for
transient hiccups; never a silent loop, never a synthesis over a hole.

### 11. The job folder is the record; reports are views *(decided 2026-07-03)*

- `output/<job>/` is the **complete, permanent, self-contained record** of a
  debate: `STATUS.md` tells its history, round folders hold every persona's words
  and every assessment (with the human's comments), and `report.md` is the
  canonical synthesis. Nothing about a debate lives anywhere else — the folder is
  what the human references, archives, and returns to.
- **Once `report.md` exists, the job is closed.** A closed debate is never re-run
  under the same name — re-debating the issue is a new job (e.g. `ccp-outage-v2`),
  and new views of a closed job go to `reports/`. This protects a report already
  delivered to peers or management from ever being silently changed.
- **Derived reports**: the human can return to any job at any time and ask for a
  new view — a management summary, a peer briefing, a re-analysis. These are
  generated from the record into `output/<job>/reports/`
  (e.g. `2026-07-10-management-summary.md`). `report.md` at the job root stays
  canonical and is never overwritten by a derived view. Every derived report
  carries the same "How this debate ran" appendix as the canonical report —
  views travel to peers and management, so each one must be self-explaining.
- **Downstream consumers pull; the lab never pushes.** A second brain, the
  social-media workspace, or any future system may ingest job folders as source
  material on explicit request ("write a LinkedIn post from the ccp-outage
  report"). The connection lives in the *consumer's* configuration, never in
  debate-lab — the same isolation rule as the branding decision. Plain markdown
  on disk means any future tool can read the archive without the lab changing.

### 12. `HOW-TO-USE.md` — the human's manual *(decided 2026-07-04)*

The lab ships with a **`HOW-TO-USE.md` at the lab root**, written for the human
user — plain language, no ICM jargon assumed, no agent instructions in it. Agents
never route through it (the `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` chain stays
the only machine entry point); this file exists so a person opening the folder for
the first time can understand the lab and run it without asking.

The guide must contain, in this order:

1. **What this is** — two or three paragraphs explaining the lab to someone who
   has never seen it: an issue goes in, several personas independently argue it
   from their own perspectives, a master compares their positions and drafts an
   assessment, and the human decides at a checkpoint whether to accept, order a
   rebuttal round, or start over. Name the key ideas (personas, expertise
   guardrails, weights, the checkpoint) in everyday words.
2. **Your first debate** — point at the two shipped samples and give the exact
   thing to say (e.g. "debate `input/sample-ccp-failure/`"), so the first run
   tests the machine, not the reader's brief-writing.
3. **Running your own debate, step by step** — numbered walkthrough of the full
   flow from the human's seat: create `input/<job>/` with a `brief.md` (what goes
   in it, how to name or omit personas); say "debate this"; what happens during
   fan-out and synthesis and roughly how long the human waits; what the
   checkpoint looks like and exactly how to respond — `> COMMENT:` lines under
   specific points, overall steer in `## Human Direction`, then one of the three
   verdicts (accept / rebuttal with panel adjustments / full reprocess); where
   the final `report.md` lands and what the round files and `STATUS.md` are.
4. **Quick recipes** — short entries for the common follow-ups: add a persona
   (pointing at `personas/_template/HOW-TO-CREATE.md`), disable or re-weight a
   persona (`CONFIG.md`), pick a panel for one debate, resume an interrupted
   debate (just ask — state lives in `STATUS.md`), and request a derived report
   from a closed job (into `output/<job>/reports/`).

**Kept current**: any design change that alters how the human interacts with the
lab — checkpoint convention, verdicts, folder layout, brief format — must update
`HOW-TO-USE.md` in the same change. A stale manual is worse than none.

## Persona Template Scaffold *(decided 2026-07-03)*

Three structural decisions shape the scaffold:

1. **Personas are workspace markdown, not harness agents.** A persona is context
   that gets loaded only when the moderator dispatches it — it costs nothing until
   then, lives in the workspace (not any machine's Claude config), and is portable
   to any tool that can read files. ICM is a deconstructed agent; the persona is
   the folder, and "the agent" is whatever AI is reading it that day.
2. **Execution is inline, one persona at a time.** The moderator plays each persona
   sequentially. Isolation is by discipline, stated in the protocol: fresh read per
   persona, prior personas' reasoning deliberately set aside before starting.
3. **Mechanics live once, in `reference/persona-protocol.md`.** Every persona's
   `AGENTS.md` is a thin pointer to it. Fixing the mechanics means editing one
   file, and all personas update.

**Every persona folder contains the same four files — and you only ever edit
three of them:**

```
personas/<persona-name>/
├── AGENTS.md      ← identical in every persona; NEVER edited (points to the shared protocol)
├── PERSONA.md     ← you write: identity, voice, worldview, biases
├── EXPERTISE.md   ← you write: domains, skill levels, blind spots
└── CONFIG.md      ← you set: enabled + weight (two lines)
```

The `_template/` folder carries one extra file, `HOW-TO-CREATE.md`, which is
deleted from every copy.

### `reference/persona-protocol.md` — the shared mechanics (one copy)

Defines, for every persona:

- **Read order**: my `PERSONA.md` → my `EXPERTISE.md` → the debate input.
- **Prerequisite check**: before writing anything, verify my required input
  exists (round 1: the debate brief; rebuttal: the commented assessment).
  Missing → stop and report; never write from a guess.
- **Round behavior**: round 1 — read `input/<job>/` only, never another persona's
  output. Rebuttal rounds — read the commented master assessment, **my own
  previous round file** (the position I am defending or revising), and the debate
  input; still never another persona's full output.
- **Common output structure**, every round file:
  1. Position
  2. Strongest Arguments
  3. Biggest Risk
  4. What Would Change My Mind
  5. Question for the Other Side
  6. Confidence Notes (anywhere I spoke outside my expert domains)
  7. Changed or Held — and why *(rebuttal rounds only)*
- **Guardrails by expertise level**: `expert` — argue with authority; `working` —
  contribute, flag uncertainty; `aware` — perspective only; `none` — defer.
  Never invent facts.
- **Human direction**: in rebuttal rounds, `> COMMENT:` lines and the
  `## Human Direction` section of the assessment are the human's voice — they
  outrank the master's framing, and any comment aimed at me must be explicitly
  addressed in my output.
- **Isolation discipline**: one persona at a time; set aside prior personas'
  reasoning before starting.

### The template files

**`AGENTS.md`** — identical in every persona, rarely edited:

```markdown
# Persona: <name>

1. Read `../../reference/persona-protocol.md` — it defines how all personas work.
2. Read `PERSONA.md` and `EXPERTISE.md` in this folder — they define who I am.
3. Check `CONFIG.md` — if `enabled: false`, stop and report this persona is disabled.
4. Follow the protocol.
```

**`PERSONA.md`** — the identity (the main creative work of making a persona):

```markdown
# <Persona Name>

## Who I Am
<one paragraph: role, background, years and kind of experience>

## Voice
<how I speak: terse/warm/formal; characteristic phrasings>

## Worldview & Values
<what I optimize for; what "good" looks like to me>

## How I Approach Problems
<my method: e.g. check logs first, rule out the network, think in failure domains>

## Declared Biases
<known leanings, stated openly so the master can weigh them>
```

**`EXPERTISE.md`** — the guardrails:

```markdown
# Expertise: <Persona Name>

| Domain | Level | Notes |
|--------|-------|-------|
| <domain> | expert | <what specifically> |
| <domain> | working | |
| <domain> | aware | |

Levels: expert / working / aware / none — behavior per level is defined in the
persona protocol.

## Blind Spots
<things this persona must explicitly defer on, even if asked directly>
```

**`CONFIG.md`** — exactly two lines, machine-parsed on every run. The template
ships with `enabled: false`, so every new persona starts disabled by default
(matching HOW-TO-CREATE step 4):

```
enabled: false
weight: 3
```

Only recognized values: lowercase keys, `true`/`false`, integer weight `1`–`5`.
Anything else and the moderator treats the persona as misconfigured and reports it
rather than guessing.

**`HOW-TO-CREATE.md`** — the build rules (deleted from copies). It opens by
stating the rule: *your new folder has five files — you will edit three, leave one
untouched, and delete one.* Then the steps:

1. Copy `personas/_template/` to `personas/<kebab-case-name>/` — the folder name
   is the persona's name.
2. **Edit** `PERSONA.md` — identity, voice, worldview, declared biases.
3. **Edit** `EXPERTISE.md` — domains with levels, blind spots.
4. **Edit** `CONFIG.md` — set the weight (1–5); **start with `enabled: false`**
   until tested.
5. **Do not touch** `AGENTS.md` — it is identical in every persona and simply
   points to the shared protocol.
6. **Delete** `HOW-TO-CREATE.md` from your copy.
7. Add a row to `reference/roster.md`.
8. Test solo: explicitly ask to solo-test this persona on a small question — the
   solo-test request is the one thing that can run a persona while it is still
   disabled. Check the output follows the protocol structure and respects the
   expertise guardrails.
9. Flip `enabled: true`.

Starting disabled makes the kill switch double as a build guard — a half-built
persona can sit in the folder indefinitely without ever joining a debate.

## Proposed Folder Structure

```
debate-lab/
├── CLAUDE.md                     ← pointer to AGENTS.md
├── AGENTS.md                     ← workspace identity (Layer 0)
├── CONTEXT.md                    ← router (Layer 1): debate runs → moderator/; new personas → _template/
├── HOW-TO-USE.md                 ← the human's manual: what the lab is + step-by-step usage (people read it; agents never route through it)
│
├── personas/                     ← Layer 2, fan-out
│   ├── _template/                ← ready-to-copy persona skeleton (never debates)
│   │   ├── HOW-TO-CREATE.md      ← rules for building a new persona
│   │   ├── AGENTS.md             ← thin pointer to reference/persona-protocol.md (never edited)
│   │   ├── PERSONA.md            ← identity, voice, worldview
│   │   ├── EXPERTISE.md          ← domains + skill levels (the guardrails)
│   │   └── CONFIG.md             ← enabled: true/false + weight: 1–5
│   ├── windows-admin/            ← each persona: same four files (no HOW-TO)
│   │   ├── AGENTS.md
│   │   ├── PERSONA.md
│   │   ├── EXPERTISE.md
│   │   └── CONFIG.md
│   ├── linux-admin/…
│   ├── cyberark-l3/…
│   ├── network-engineer/…
│   └── stoic/…                   ← Marcus Aurelius-style voice
│
├── moderator/AGENTS.md           ← Layer 2, entry point: panel resolution, dispatch, checkpoint routing
│
├── synthesis/AGENTS.md           ← Layer 2, fan-in: the master
│
├── reference/                    ← Layer 3, standing rules (all human-editable)
│   ├── roster.md                 ← library index: one row per persona
│   ├── persona-protocol.md       ← shared persona mechanics (read order, output structure, guardrails)
│   ├── report-format.md          ← assessment + report formats: comment convention, position evolution, provenance appendix
│   └── debate-settings.md        ← max rounds (default 2), checkpoint rules
│
├── input/                        ← Layer 4: one folder per debate
│   ├── sample-ccp-failure/       ← shipped sample: technical troubleshooting (first-run test)
│   ├── sample-account-maturity/  ← shipped sample: moral/policy question (stoic leads)
│   └── <job>/
│       ├── brief.md              ← the issue + panel selection (required)
│       ├── logs/                 ← optional supporting material
│       └── links.md              ← optional related URLs/tickets
├── output/                       ← Layer 4: mirrors input job names
│   └── <job>/
│       ├── STATUS.md             ← moderator-owned: state snapshot + event log (read first to resume)
│       ├── round-1/
│       │   ├── <persona>.md      ← one per participating persona
│       │   └── master-assessment.md  ← + human comments at the checkpoint
│       ├── round-2/…             ← only if a rebuttal round ran
│       ├── superseded/…          ← rounds displaced by a reprocess (kept, never deleted)
│       ├── report.md             ← final synthesis (canonical; once written, the job is closed)
│       └── reports/              ← derived views, generated later on request
│           └── <date>-<audience>.md   (e.g. 2026-07-10-management-summary.md)
└── _design/                      ← seed chain (CLAUDE/AGENTS/CONTEXT) + SPEC.md + DECISIONS.md; not part of the run
```

## Flow Summary

1. Human creates `input/<job>/` with `brief.md` (plus logs, links, other context)
   and says "debate this" — optionally naming or omitting personas in the brief
   or the prompt.
2. The router sends the run to the **moderator**, which resolves the panel: start
   from all personas, drop any with `enabled: false` in their `CONFIG.md`, then
   apply the brief/prompt selections and omissions.
3. Fan-out (dispatched by the moderator): each panel persona reads the whole input
   folder and writes `output/<job>/round-1/<persona>.md`. No cross-reading in round 1.
4. Fan-in: master reads all round-1 outputs and writes
   `round-1/master-assessment.md` — per-persona positions, conflicts, weights
   considered, and a rebuttal recommendation with a proposed participant list.
5. **Human checkpoint**: human reviews persona outputs + assessment, adds
   comments into the assessment file, then gives a verdict — the moderator routes
   it: accept (→ step 7), rebuttal with a confirmed panel (→ step 6), or full
   reprocess (→ step 3).
6. Rebuttal round (max 1 by default): participating personas read the
   commented assessment — not each other's full files — and write
   `round-2/<persona>.md`, each explicitly stating changed-or-held and why.
   Return to step 4.
7. Master writes `output/<job>/report.md` — agreements, conflicts, position
   evolution across rounds, unresolved items — and tells the human where it is.

Throughout, the moderator keeps `output/<job>/STATUS.md` current after every
persona completion and every transition (dispatch, round completion, checkpoint
verdict). A fresh session resumes from the file alone — whether the pause was a
planned checkpoint, token exhaustion, or a manual abort mid-round — re-running
only the personas not logged complete.

## Build & Integration Protocol *(for building from this seed)*

Follow this when asked to build (or rebuild) the lab from `_design/`.

### Where to build

1. **`_design/` sits inside a project folder** (its parent is the lab folder itself — empty,
   partial, or complete): build into the parent folder. Missing pieces are created per this spec;
   existing human material is kept per the preservation rule below. Confirm before overwriting
   any machine file that differs from what the spec describes.
2. **`_design/` was dropped directly into a workspace root** (its parent contains other projects
   or identifies itself as a workspace root): create `debate-lab/` beside it, **move `_design/`
   inside it**, then build as in case 1.

### What to build

Everything in the Proposed Folder Structure section: the front-door chain (`CLAUDE.md` →
`AGENTS.md` → `CONTEXT.md` router), the `HOW-TO-USE.md` user guide (per requirement 12 — plain
language, the four sections in order), `moderator/AGENTS.md`, `synthesis/AGENTS.md`, the four
`reference/` files, `personas/_template/` (per the Persona Template Scaffold section, including
`HOW-TO-CREATE.md`), the five starter personas (`windows-admin`, `linux-admin`, `cyberark-l3`,
`network-engineer`, `stoic` — each with the four files, registered in `reference/roster.md`,
shipped `enabled: true` since they are the tested starter set), the two shipped sample inputs
(`input/sample-ccp-failure/`, `input/sample-account-maturity/`), and an empty `output/`.

Where this spec gives verbatim scaffolds (the persona template files), copy them; where it gives
requirements (stage behavior, reference file contents, sample briefs), write files that satisfy
them.

### Preservation rule (rebuilds)

A rebuild restores machine files but never clobbers what the human made: personas the human added
or edited, real `input/<job>/` folders, and **everything under `output/`** — job folders are the
permanent record (requirement 11) and are never touched by a rebuild. Any machine file that
exists but was customized gets a confirmation before overwrite.

### Plugging into the parent workspace

After building, walk up from the lab folder and integrate — this is what makes the folder a true
drop-in:

1. **Parent workspace has a `CONTEXT.md` router**: add a routing row for the lab (e.g.
   *"Multi-persona debates, adding debate personas → debate-lab/CLAUDE.md"*), if one is not
   already there. Follow that router's own conventions for row format. Replace any row that still
   points at `_design/` as "not built yet".
2. **Parent has `CLAUDE.md`/`AGENTS.md` but no router**: add a short pointer to the lab in the
   parent `AGENTS.md` (or wherever that workspace lists its projects), matching its existing style.
3. **No parent chain at all**: the lab stands alone — its own `CLAUDE.md` is the entry point.
   Offer to create a minimal workspace-root chain, but do not create one unasked.

Always report exactly which parent files were changed (or that none needed changing).

### Verify

Structural, not end-to-end — a debate cannot run unattended because every round ends at a human
checkpoint (requirement 7):

- Every persona folder has exactly the four files; `_template/` additionally has `HOW-TO-CREATE.md`.
- Every `CONFIG.md` parses per the pinned format (requirement in the scaffold section).
- `reference/roster.md` rows match the persona folders one-to-one (excluding `_template/`).
- Both sample input folders contain a `brief.md`.
- `HOW-TO-USE.md` exists at the lab root, has the four required sections in order (what this is;
  first debate; step-by-step; quick recipes), and its instructions match the built lab (folder
  names, checkpoint convention, the three verdicts).
- The parent router row (if any) resolves.

Then tell the human the lab is ready and offer to run a first debate on a shipped sample.

## Out of Scope (for v1)

- Personas debating in real time / taking turns within a round
- Automatic persona generation from the issue text
- Cross-project routing (debate-lab consuming teaching-lab outputs)
- **Branding / presentation of the final report.** The deliverable is plain
  markdown (`report.md`). Turning it into a branded PDF is a different project's
  job (the human's brandkit workspace) and happens only on explicit request —
  "format `output/<job>/report.md` with my corporate brandkit" — never as a
  standing connection. Per the workspace root rule: no cross-loading context
  between projects.
