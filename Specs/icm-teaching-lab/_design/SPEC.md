# ICM Teaching Lab — Build Spec

**Status**: Retro-documented from the as-built lab (2026-07-03). The lab was built first and this
spec was written from it, so a rebuild from this file alone reproduces the working structure.
`DECISIONS.md` alongside this file records the reasoning and rejected alternatives.

**This folder is also a drop-in build seed**: copy `_design/` into any workspace and ask the agent
to build it out — the **Build & Integration Protocol** section at the end tells the builder where
to build and how to plug the lab into the surrounding workspace.

---

## Goal

Build a small teaching workspace, `icm-teaching-lab/`, that demonstrates Interpretable Context
Methodology (ICM), also called Model Workspace Protocol (MWP). It is the next step after a
hello-world example: the agent moves through a small but realistic **pipeline** — brief → draft →
review → final — reading only the context each stage needs, writing a visible artifact at every
step, and following human-editable rulebooks.

This is the pipeline pattern, in contrast to the debate lab's fan-out/fan-in pattern. Same
building blocks: folders, markdown instructions, a router, references, per-job outputs.

The workflow itself turns a rough human note (a raw request) into a short, polished announcement.
The announcement is not the point — the visible, inspectable, file-based process is.

## Core Requirements

### 1. Front-door chain (Layers 0–1)

- `CLAUDE.md` — one line, redirects to `AGENTS.md` (the harness auto-loads this filename).
- `AGENTS.md` — workspace identity: what this lab is, the protocol (route first, one stage at a
  time, per-job outputs, read only the reference files the current stage names).
- `CONTEXT.md` — the router: a table mapping request types to the four stage folders, a workspace
  map with the layer of every folder, and a **default run** rule: a broad request ("run the ICM
  teaching lab") starts at `01-brief/` and follows the chain through `04-final/`.
- `README.md` — for humans, not the agent: what the lab does, how to invoke it, which files to
  inspect, and the design notes (see requirement 8).

### 2. Four numbered stages (Layer 2)

Each stage folder contains exactly one file, `AGENTS.md`, answering three questions: what do I
read, what do I write and where, what are the rules and where do I go next.

| Stage | Reads | Writes | Role |
|-------|-------|--------|------|
| `01-brief/` | naming convention, the raw input | `output/<job>/brief.md` | Restate the rough request as a structured brief (Goal / Audience / Key Message / Required Points / Tone) |
| `02-draft/` | naming convention, the brief, style guide | `output/<job>/draft.md` | First draft **from the brief, not the raw input**, plus 1–3 notes for review |
| `03-review/` | naming convention, draft, brief, quality bar, style guide | `output/<job>/review.md` | Check against the quality bar: Passes / Needs Work / Recommended Fixes / Ready For Final (yes-or-no verdict) |
| `04-final/` | naming convention, draft, review, style guide | `output/<job>/final.md` | Apply the review and produce the finished announcement |

Chaining rule in every stage: if the user asked for only this stage, stop and report; otherwise
read the next stage's `AGENTS.md` and continue.

### 3. Per-job inputs and outputs (Layer 4)

- Inputs live in `input/`, one file per job, named `raw-request-<job>.md`. The `<job>` part of the
  filename is the job name; bare `raw-request.md` maps to job `default`. The user can override the
  job name in the request.
- Each job writes to its own folder, `output/<job>/`, created on first write. Never write stage
  outputs directly into `output/` — every output belongs to a job folder. This lets multiple jobs
  exist side by side without overwriting each other.
- Input file selection: use the one the user names; if only one exists, use it; if several exist
  and none was named, ask.
- Reruns overwrite only that job's folder; to keep an earlier result, rerun under a new job name.
- All of this lives in `reference/naming-convention.md` (full scaffold below) — stages point at
  it rather than restating it.

### 4. Prerequisite guards — verify before working

Every stage after the first checks its upstream files before working: if
`output/<job>/brief.md` (or `draft.md`, `review.md`) is missing or still a placeholder, the stage
runs the earlier stage first instead of working from an empty input. Stage 2 additionally carries
an explicit **Prerequisites table** stating each precondition, who sets it (stage 1, or the human),
and how often (every run vs. standing material edited once) — this table is itself a teaching
artifact showing how ICM makes preconditions explicit.

### 5. Bounded review loop

If stage 3's verdict is "Ready For Final: no", return to stage 2, revise the draft using the
recommended fixes, and review again — **at most once**, then proceed regardless. Never an
unbounded loop.

### 6. Reference material is standing and human-editable (Layer 3)

Three rulebooks in `reference/`, and editing them is the intended way to change behavior — never
rewriting stage logic:

- `style-guide.md` — voice and format rules (used by stages 2 and 4).
- `quality-bar.md` — the review checklist (used by stage 3). Reusable rules only; anything
  specific to one request (audience, required points) lives in the brief, so the file works
  unchanged for a different input.
- `naming-convention.md` — job names, input selection, output locations, rerun rules.

### 7. Human-only folders

- `docs/` — plain-English guides for people (e.g. a folder-structure walkthrough using an
  office metaphor, a beginner explainer). The agent never needs these to do the work.
- `_tmp/` — scratch space (e.g. run transcripts). The leading underscore marks it as not part of
  the system.
- `_design/` — this folder: the spec and decision log. Also not part of the run.

### 8. Shipped sample input

The lab ships with one prefilled input, `input/raw-request.md` (job `default`): a rough note
announcing a fictional internal workshop called "Control Your Agent" (full scaffold below). First
runs test the machine, not the human's request-writing. Real jobs are added as
`raw-request-<job>.md` files alongside it.

## Folder Structure

```
icm-teaching-lab/
├── CLAUDE.md                     ← pointer to AGENTS.md
├── AGENTS.md                     ← workspace identity (Layer 0)
├── CONTEXT.md                    ← router (Layer 1): stage table, workspace map, default run
├── README.md                     ← human-facing introduction and design notes
│
├── 01-brief/AGENTS.md            ← Layer 2: raw input → structured brief
├── 02-draft/AGENTS.md            ← Layer 2: brief + style guide → draft
├── 03-review/AGENTS.md           ← Layer 2: draft vs quality bar → review + verdict
├── 04-final/AGENTS.md            ← Layer 2: draft + review → final announcement
│
├── reference/                    ← Layer 3, standing rules (all human-editable)
│   ├── naming-convention.md      ← job names, input selection, output locations, reruns
│   ├── style-guide.md            ← voice and format rules
│   └── quality-bar.md            ← review checklist
│
├── input/                        ← Layer 4: one file per job
│   ├── raw-request.md            ← shipped sample (job "default")
│   └── raw-request-<job>.md      ← real jobs, added by the human
├── output/                       ← Layer 4: one folder per job, created on first write
│   └── <job>/
│       ├── brief.md
│       ├── draft.md
│       ├── review.md
│       └── final.md
│
├── docs/                         ← guides for humans (optional; regenerable)
├── _tmp/                         ← scratch space (not versioned context)
└── _design/                      ← this folder: seed chain + SPEC.md + DECISIONS.md
```

## Flow Summary

1. Human drops `input/raw-request-<job>.md` (or uses the shipped sample) and says "run the ICM
   teaching lab" — or asks for a single stage by name.
2. The front-door chain routes: `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` → the right stage.
3. `01-brief` resolves the job name per the naming convention and writes `output/<job>/brief.md`.
4. `02-draft` verifies the brief exists, reads it plus the style guide, writes `draft.md`.
5. `03-review` verifies the draft, checks it against the quality bar and brief, writes `review.md`
   with a yes/no verdict. On "no": one revision loop back to stage 2, then proceed regardless.
6. `04-final` applies the review and writes `final.md`, then tells the human the lab is done and
   names the key files to inspect.

## File Scaffolds

The exact contents of every machine-read file, verbatim. A rebuild copies these as-is.
(`README.md` and `docs/` are human prose — content requirements are listed after the scaffolds
and may be regenerated rather than copied.)

### `CLAUDE.md`

````markdown
Go to the AGENTS.md file in this folder and follow those instructions.
````

### `AGENTS.md`

````markdown
# ICM Teaching Lab - Workspace Identity

This workspace is a teaching example for Interpretable Context Methodology (ICM), also called Model
Workspace Protocol (MWP).

It is the next step after `iScaleLabs/hello-world`: instead of writing three words, the agent moves through
a small but realistic workflow with input, reference material, stage outputs, and review.

## Protocol

- Read `CONTEXT.md` before opening any stage folder.
- Use the router table in `CONTEXT.md` to decide where to go.
- Follow one stage at a time.
- Each stage writes its result to a per-job folder, `output/<job>/`. The job name comes from the
  input filename — see `reference/naming-convention.md`. This lets multiple jobs exist side by side
  without overwriting each other.
- Reference files live in `reference/`; read only the files named by the current stage.
- Input files live in `input/`, named `raw-request-<job>.md`; outputs and working artifacts live in
  `output/<job>/`.
````

*(If the lab is built as the next step after a different hello-world example — or none — adjust
the second paragraph's pointer accordingly.)*

### `CONTEXT.md`

````markdown
# ICM Teaching Lab - Router

Use this table to route requests into the correct stage. The default learning path runs stages in order:

`01-brief` -> `02-draft` -> `03-review` -> `04-final`

## Routing Rules

| If the request involves...                                | Route to...                            | Stage purpose                       |
|-----------------------------------------------------------|----------------------------------------|-------------------------------------|
| Starting the tutorial, reading the input, making a brief   | [01-brief/AGENTS.md](01-brief/AGENTS.md) | Turn raw input into a clear brief   |
| Drafting from an approved or generated brief              | [02-draft/AGENTS.md](02-draft/AGENTS.md) | Create a first draft                |
| Reviewing, scoring, checking against rules, improving      | [03-review/AGENTS.md](03-review/AGENTS.md) | Produce review notes and fixes      |
| Finishing, publishing, final output, completion            | [04-final/AGENTS.md](04-final/AGENTS.md) | Create the final polished artifact  |
| Rebuilding the lab, design questions, "why is it this way" | [_design/CLAUDE.md](_design/CLAUDE.md) | Design record and build seed        |

## Workspace Map

| Folder        | Layer | Purpose                                                            |
|---------------|-------|--------------------------------------------------------------------|
| `AGENTS.md`   | 0     | Workspace identity: where the agent is                             |
| `CONTEXT.md`  | 1     | Router: where the agent should go                                  |
| `01-brief/`   | 2     | Stage instructions for extracting the work brief                   |
| `02-draft/`   | 2     | Stage instructions for drafting                                    |
| `03-review/`  | 2     | Stage instructions for reviewing against references                 |
| `04-final/`   | 2     | Stage instructions for finalizing                                  |
| `reference/`  | 3     | Rules, style guidance, and examples                                |
| `input/`      | 4     | Starting material supplied by the human                            |
| `output/`     | 4     | Files created by the workflow                                      |
| `_design/`    | —     | Design record and build seed (SPEC.md + DECISIONS.md); not part of the run |

## Default Run

If the user says "run the ICM teaching lab" or gives a broad request with no specific stage, start at
`01-brief/AGENTS.md` and follow the chain until `04-final/AGENTS.md` is complete.
````

### `01-brief/AGENTS.md`

````markdown
# Stage 1 - Brief

You are creating the structured brief.

## Read

| File | Why |
|------|-----|
| `../reference/naming-convention.md` | How to pick the input file and derive the job name |
| `../input/raw-request-<job>.md` | Source material from the human (see naming convention) |

## Write

Write `../output/<job>/brief.md`. Create the job folder if it does not exist.

Use this structure:

```markdown
# Brief

## Goal

## Audience

## Key Message

## Required Points

## Tone
```

## Constraints

- Do not draft the announcement yet.
- Keep the brief short and usable.
- If the user asked for only this stage, stop here and report that the brief is ready.
- Otherwise, read `../02-draft/AGENTS.md` and follow its instructions.
````

### `02-draft/AGENTS.md`

````markdown
# Stage 2 - Draft

You are creating the first draft from the brief.

## Prerequisites

Before this stage can run, these must already be in place:

| Prerequisite | Who sets it | When |
|--------------|-------------|------|
| `../output/<job>/brief.md` is filled in (not the placeholder) | Stage 1 (`../01-brief/AGENTS.md`) | Every run |
| `../input/raw-request-<job>.md` describes the current job | The human | Every run (this is the per-job input) |
| `../reference/style-guide.md` reflects the desired voice | The human | Once — reusable standing material; edit only when the voice should change |

The job name comes from `../reference/naming-convention.md`. If the brief is missing
or still a placeholder, complete Stage 1 first.

## Read

| File | Why |
|------|-----|
| `../reference/naming-convention.md` | How to resolve the job name and paths |
| `../output/<job>/brief.md` | The structured working brief |
| `../reference/style-guide.md` | Voice and format rules |

## Write

Write `../output/<job>/draft.md`.

Use this structure:

```markdown
# Draft

## Announcement

[draft text]

## Notes For Review

[1-3 notes about choices made]
```

## Constraints

- If `../output/<job>/brief.md` is missing or still contains only its placeholder line, complete
  `../01-brief/AGENTS.md` first.
- Do not review the draft yet.
- Keep the announcement short.
- Follow the style guide.
- If the user asked for only this stage, stop here and report that the draft is ready.
- Otherwise, read `../03-review/AGENTS.md` and follow its instructions.
````

### `03-review/AGENTS.md`

````markdown
# Stage 3 - Review

You are reviewing the draft against the quality bar.

## Read

| File | Why |
|------|-----|
| `../reference/naming-convention.md` | How to resolve the job name and paths |
| `../output/<job>/draft.md` | The current draft |
| `../output/<job>/brief.md` | Goal, audience, and required points to check against |
| `../reference/quality-bar.md` | Review criteria |
| `../reference/style-guide.md` | Voice and format rules |

## Write

Write `../output/<job>/review.md`.

Use this structure:

```markdown
# Review

## Passes

## Needs Work

## Recommended Fixes

## Ready For Final
Yes or no, with one sentence explaining why.
```

## Constraints

- If `../output/<job>/draft.md` is missing or still contains only its placeholder line, complete
  `../02-draft/AGENTS.md` first.
- Be specific and useful.
- Do not write the final announcement yet.
- If something needs work, propose the fix.
- If the user asked for only this stage, stop here and report the review verdict.
- If `Ready For Final` is no, return to `../02-draft/AGENTS.md`, revise the draft using the
  recommended fixes, then review it again. Do this loop at most once, then proceed regardless.
- Otherwise, read `../04-final/AGENTS.md` and follow its instructions.
````

### `04-final/AGENTS.md`

````markdown
# Stage 4 - Final

You are creating the final announcement.

## Read

| File | Why |
|------|-----|
| `../reference/naming-convention.md` | How to resolve the job name and paths |
| `../output/<job>/draft.md` | The draft to improve |
| `../output/<job>/review.md` | Review notes and recommended fixes |
| `../reference/style-guide.md` | Final voice and format rules |

## Write

Write `../output/<job>/final.md`.

Use this structure:

```markdown
# Final

## Announcement

[final text]

## Completion Note

Done. This workflow demonstrates ICM routing, staged context, reference material, and visible outputs.
```

## Constraints

- If `../output/<job>/draft.md` or `../output/<job>/review.md` is missing or still contains only its
  placeholder line, complete the earlier stages first.
- Apply the review notes.
- Keep the final artifact polished but compact.
- When finished, tell the user the teaching lab is ready and name the key files to inspect.
````

### `reference/naming-convention.md`

````markdown
# Naming Convention

How input files map to output names, so multiple jobs can exist side by side without
overwriting each other.

## Job Name

Every run has a **job name**, derived from the input filename:

| Input file | Job name |
|------------|----------|
| `input/raw-request-ccp.md` | `ccp` |
| `input/raw-request-store-hours.md` | `store-hours` |
| `input/raw-request.md` | `default` |

Pattern: `raw-request-<job>.md` → job name is `<job>`. Use lowercase with hyphens
between words.

The user can override the job name by stating one in the request (e.g. "run the lab
on the ccp input, but name the output ccp-v2").

## Choosing the Input File

1. If the user names an input file or job, use that one.
2. If only one `raw-request*.md` file exists in `input/`, use it.
3. If several exist and the user did not specify, ask which one.

## Output Location

Each job writes to its own folder under `output/`:

```
output/<job>/brief.md
output/<job>/draft.md
output/<job>/review.md
output/<job>/final.md
```

Create the folder on first write. Never write stage outputs directly into `output/`
— every stage output belongs to a job folder.

## Reruns

Rerunning a job overwrites only that job's folder. To keep an earlier result, rerun
under a new job name (e.g. `ccp-v2`) or copy the folder aside first.
````

### `reference/style-guide.md`

````markdown
# Style Guide

Use this guide when drafting and finalizing the announcement.

## Voice

- Clear
- Practical
- Friendly
- Confident without hype

## Format

- Use a short headline.
- Use 2 to 4 short paragraphs.
- Include a clear invitation.
- Avoid jargon unless it is briefly explained.

## Avoid

- Overpromising
- Dense technical language
- Long lists
- Marketing fluff
````

### `reference/quality-bar.md`

````markdown
# Quality Bar

Use this checklist during review. Check the draft against the brief for anything input-specific.

| Criterion         | Question                                                              |
|-------------------|------------------------------------------------------------------------|
| Clear audience    | Is it obvious who this is for?                                        |
| Clear promise     | Is the main benefit easy to understand?                               |
| Required points   | Does it cover every required point listed in the brief?               |
| Practical tone    | Does it sound useful rather than flashy?                              |
| Clear invitation  | Does it clearly tell the reader what to do next?                      |
````

*(Close the file with one line: if a draft misses a criterion, name the issue and propose a
specific fix.)*

### `input/raw-request.md` — the shipped sample

````markdown
# Raw Request

We are launching a small internal workshop called "Control Your Agent."

The workshop teaches people how to guide an AI agent using folders, markdown instructions, router files,
stage files, references, and outputs instead of a complicated app framework.

Audience:

- curious operators
- workflow builders
- non-engineers who use AI tools

The announcement should be short, practical, and friendly. It should invite people to try the workshop and
make it clear that no coding experience is required.
````

### Human prose — content requirements (regenerable, not verbatim)

- **`README.md`**: what the lab demonstrates and why it matters; how to invoke it (the "run the
  ICM teaching lab" prompt plus per-stage prompts); a files-to-inspect table; design notes
  covering the shared-`output/` choice, the placeholder-as-guard idea, and reusable-vs-per-job
  rules; and the teaching point (routing explicit, instructions local, references separated,
  outputs inspectable, each step changeable independently).
- **`docs/folder-structure-explained.md`** (optional): plain-English walkthrough of every folder
  for a non-technical reader — the as-built version uses an office metaphor (front-door files as
  signage, stages as rooms, input/output as inbox/outbox, reference as the rulebook shelf) and
  closes with the five folder roles: orientation, process, standards, materials, human-only.
- **`docs/explain-it-to-me.md`** (optional): a beginner explainer of the lab and ICM.
- When rebuilding in place, keep existing `docs/`, `README.md`, real inputs, and `output/` job
  folders — they are the human's material and record; only the machine files above are restored
  from scaffold.

## Build & Integration Protocol *(for building from this seed)*

Follow this when asked to build (or rebuild) the lab from `_design/`.

### Where to build

1. **`_design/` sits inside a project folder** (its parent is the lab folder itself — empty,
   partial, or complete): build into the parent folder. Missing files are created from the
   scaffolds; existing human material (inputs, outputs, docs, README) is kept per the rule above.
   Confirm before overwriting any machine file that differs from its scaffold.
2. **`_design/` was dropped directly into a workspace root** (its parent contains other projects
   or identifies itself as a workspace root): create `icm-teaching-lab/` beside it, **move
   `_design/` inside it**, then build as in case 1.

### Plugging into the parent workspace

After building, walk up from the lab folder and integrate — this is what makes the folder a true
drop-in:

1. **Parent workspace has a `CONTEXT.md` router**: add a routing row for the lab (e.g. *"ICM
   teaching lab, staged workflow examples → icm-teaching-lab/CLAUDE.md"*), if one is not already
   there. Follow that router's own conventions for row format.
2. **Parent has `CLAUDE.md`/`AGENTS.md` but no router**: add a short pointer to the lab in the
   parent `AGENTS.md` (or wherever that workspace lists its projects), matching its existing style.
3. **No parent chain at all**: the lab stands alone — its own `CLAUDE.md` is the entry point.
   Offer to create a minimal workspace-root chain, but do not create one unasked.

Always report exactly which parent files were changed (or that none needed changing).

### Verify

Finish by running the shipped sample end to end ("run the ICM teaching lab" on
`input/raw-request.md`) and confirming all four files appear under `output/default/`.

## Out of Scope (for v1)

- Multiple pipelines or branching routes — one linear pipeline with one bounded review loop.
- Automation (scripts, hooks, harness agents) — the folder structure and markdown are the whole
  system, by design.
- Cross-project routing (the teaching lab consuming or feeding other workspaces' outputs).
- Branded or formatted deliverables — the output is plain markdown.
