# ICM Workspace Template — Build Spec

**Status**: Design drafted 2026-07-04 from an interview with the human; open points were resolved
in that interview and are marked *(decided 2026-07-04)*. `DECISIONS.md` alongside this file
records the reasoning and rejected alternatives. Ready to build on the human's go.

**This folder is also a drop-in build seed**: copy `_design/` into any workspace and ask the
agent to build it out — the **Build & Integration Protocol** section at the end tells the builder
where to build and how to (optionally) register the template with the surrounding workspace.

**Mind the two levels.** This spec builds `_ICM-Template/` — the template. The template, once
built, is itself copied and renamed to start new ICM workspaces. When this spec says "the
template" it means `_ICM-Template/`; when it says "the new workspace" it means a renamed copy of
it that a person is setting up.

---

## Goal

Build `_ICM-Template/`, a **copy-and-rename seed for starting brand-new ICM workspaces from
scratch**. A person copies the folder to wherever the workspace should live, renames it to the
workspace's name, points an AI agent at it, and the template takes it from there: an optional
guided interview to get to the heart of the problem the workspace will solve, a reviewable build
plan, a resumable build-out, and a mandatory post-build audit — all following ICM itself
(staged, file-driven, human in control).

The template must be **easy and simple** — get a person started quickly with something small —
while staying **flexible** (any kind of workspace, any scripting language, shareable with people
whose setups we know nothing about) and **robust** (interruptions never lose work; the human can
take the reins at any point). It must itself be a valid ICM workspace: the tool that teaches the
method must follow the method.

## Core Requirements

### 1. Usage is copy → rename → kick off; `README.md` is the human's front door

The template ships a **`README.md`** at its root — plain language, written for the person (the
agent never routes through it). Its centerpiece is a **"Step by Step: From Template to Working
Workspace" section** *(decided 2026-07-04)* — the single authoritative, numbered walkthrough of
the entire implementation, end to end. One place, complete; every other file that mentions usage
(`NEXT-STEPS.md`, `docs/explain-this-template.md`) points here rather than repeating the steps.
The walkthrough covers, in order, exactly what the person does:

1. **Copy** the entire `_ICM-Template/` folder to where the new workspace should live.
2. **Rename** the copy to the workspace's name (e.g. `incident-review/`). The folder name *is*
   the workspace name — nothing inside the template hard-codes a name.
3. **Kick off**: point your AI agent at the folder and say "set up this workspace" (or just ask
   it to read the folder). The chain routes it into setup (requirement 5).
4. **Answer the two kickoff questions** — interview or manual, and wire into the parent
   workspace (default yes).
5. **Take the interview** (or dictate, or go manual via `NEXT-STEPS.md`) — with a note that you
   can stop it at any question.
6. **Review the build plan** (`_setup/build-plan.md`) — edit it freely, do steps yourself and
   tick the boxes if you want, then say go.
7. **Let the build run** — and what to say to resume if it gets interrupted.
8. **Read the audit** (`_setup/setup-review.md`) and decide which advice to act on.
9. **Confirm you're done**: `NEXT-STEPS.md` is gone, the front door describes your workspace,
   and `_setup/` holds the record of how it was born.

Each step says what the person does, what the agent does in response, and what exists afterward.

The README also covers: what's in the box (a guided tour of the shipped files), the manual path
(requirement 2's `NEXT-STEPS.md`), the optional registration of the template itself with a
host workspace (requirement 11), and closes with the Credits section (requirement 13).

### 2. Ships minimal — the basics plus `NEXT-STEPS.md` *(decided 2026-07-04)*

The template ships **just the basics**: the front-door chain, the docs, the setup machinery, and
the reference rules — no pre-built stages, no presumed pipeline. A fresh copy is honest about
being a starting point, not a finished workspace. That honesty lives in **`NEXT-STEPS.md`** at
the template root:

- States plainly: *this workspace is a fresh, minimal copy — it is not set up yet.*
- Lists what to do to be successful, as the two paths:
  - **Guided**: tell the agent to set up the workspace and take the interview (requirement 6).
  - **Manual**: build the stages yourself — points at `docs/explain-icm.md` for what a finished
    ICM workspace needs, and at `reference/icm-checklist.md` as the target to satisfy. Notes
    that a person going manual can simply **delete this file** when they're done with it.
- The guided build's final cleanup step (requirement 7) removes this file automatically — its
  absence is the signal that setup finished (or that a human took over and finished manually).

### 3. Front-door chain ships in **seed mode** and is rewritten at build

The template contains the standard chain — `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` — but in
**seed mode**:

- `CLAUDE.md`: the standard one-line pointer to `AGENTS.md`. Never changes.
- `AGENTS.md` (Layer 0, seed mode): identifies the folder as *an ICM workspace that has not been
  set up yet*, explains the two levels (this copy will become a real workspace), and directs the
  agent to `CONTEXT.md`.
- `CONTEXT.md` (Layer 1, seed mode): routes setup requests to `_setup/AGENTS.md`, "explain this
  to me" requests to `docs/`, and anything that presumes a working workspace ("run a job",
  "process this input") to a polite stop: *this workspace isn't built yet — want to set it up?*
- **Master-copy guard** *(added at build, 2026-07-04)*: if the folder is still named
  `_ICM-Template`, it is the template master, not a copy — seed `CONTEXT.md` and
  `_setup/AGENTS.md` both refuse to set it up in place and point the human at the copy/rename
  steps. Setup runs only on renamed copies.

The **build step rewrites `AGENTS.md` and `CONTEXT.md` into workspace mode** — real identity
text and a real router for the structure the build created. The seed-mode text is gone from the
copy after setup; `_setup/` keeps the record of how the workspace came to be (requirement 12).

### 4. `docs/` — the plain-language explainers

Two documents in the style the human likes (the teaching lab's `explain-it-to-me.md`: friendly,
analogy-first, no jargon assumed):

| File | Explains |
|------|----------|
| `docs/explain-icm.md` | What ICM is and how it works — folders as architecture, the layer model (0–4), routers, stages, reference files, why plain markdown. Self-contained: a person who has never seen ICM should come away able to read any ICM workspace. |
| `docs/explain-this-template.md` | How this template builds a new workspace — copy/rename, the interview, the build plan and its checkboxes, taking the reins yourself, the audit, what seed mode means and what changes after setup. |

These are **standalone copies, not pointers** — the template travels to machines where no other
ICM material exists, so it must carry its own explanation.

### 5. Kickoff — two questions before any work

When the agent is routed into setup on a fresh copy, it asks the human exactly two things before
doing anything else:

1. **Interview or manual?** *"Want to go through a short interview so I understand what this
   workspace is for — or would you rather build it out yourself / just tell me directly?"* The
   interview (requirement 6) is the default recommendation but never forced — a human who
   already knows what they want can dictate, or go fully manual (`NEXT-STEPS.md` path).
2. **Wire into the parent? (default: yes)** If the workspace's parent folder has an ICM chain
   (a `CONTEXT.md` router, or `CLAUDE.md`/`AGENTS.md` without one), offer to register the new
   workspace there when the build completes — router row per the parent's own row conventions,
   or a pointer in the parent's `AGENTS.md` if it has no router. Default is yes. If the parent
   has no ICM chain at all, say so and skip the question — the workspace stands alone.

Both answers are recorded in the build plan (requirement 7), so an interrupted setup does not
re-ask.

### 6. The interview — get to the heart of the problem *(decided 2026-07-04)*

The interview exists to give the agent what a folder name never can: **what problem this
workspace solves, for whom, and what "done" looks like**. Rules:

- **Guided by `_setup/interview-guide.md`** — a human-editable Layer 3 file holding the question
  areas, so the interview can be tuned without touching stage logic. Core areas: the problem
  being solved and for whom; what comes in (inputs) and what should come out (outputs/artifacts);
  the shape of the work (one flow? stages? review loops? does anything fan out?); the rules and
  standards the work must respect (style, quality bars, constraints); who/what does the work
  (AI, human, both — where the human wants control points); how often and how it's triggered;
  what already exists that should be preserved or imported.
- **One question at a time**, conversational, adapted to previous answers — not a form.
- **The human can stop at any question** *(decided 2026-07-04)*: every question carries a
  standing exit — "enough questions" / "just build it" — and the agent states this up front so
  the human knows the door is always open.
- **The agent can also call it**: when it judges it has enough to design the workspace, it says
  so and offers to stop early.
- **Closing sweep**: however the interview ends, the agent asks one final question — *"anything
  important I haven't asked about?"* — before concluding. Nothing concludes without that sweep.
- **Everything captured lands in `_setup/interview-notes.md`** — organized by topic, in the
  human's own terms, including answers implied by the kickoff questions. If the interview was
  skipped, the file still gets written with whatever the human dictated, marked as such. This
  file is the design input; the human can edit it directly before the plan is drawn up.

### 7. The build plan — a resumable checklist *(decided 2026-07-04)*

Between the interview and the build sits **`_setup/build-plan.md`**: the full list of build-out
steps as a **markdown checklist** (`- [ ]` / `- [x]`), derived from the interview notes. It is
both the reviewable design and the resume mechanism:

- **Contents**: the kickoff answers (interview taken? parent wiring yes/no?); the intended
  folder structure of the finished workspace (a tree, with one line of purpose per entry); then
  every build step as a checkbox — each folder, each stage `AGENTS.md`, each reference file,
  the front-door rewrite (requirement 3), the parent wiring (if yes), the cleanup
  (delete `NEXT-STEPS.md`), and the audit (requirement 10) as the always-last item.
- **Review checkpoint**: the plan is presented to the human before any box is ticked. The human
  can edit the file directly, strike steps, add steps, or reorder — then says go. (The human's
  edits *are* the approval mechanism; no separate sign-off format.)
- **Check off as you go**: the agent marks each step `- [x]` **immediately after completing it**,
  never in batches — so an interruption (error, token exhaustion, closed session) loses at most
  one step's work.
- **Resumption rule**: any session touching a workspace whose `_setup/build-plan.md` has
  unchecked boxes reads the plan first, cross-checks checked items against what is actually on
  disk (a checked item whose file is missing gets unchecked and redone; an unchecked item whose
  file exists is verified and checked), then continues from the first unchecked box. State lives
  in the file, not in any session's memory.
- **The human can take the reins at any point** *(decided 2026-07-04)*: the plan is plain
  markdown — a person can do any step by hand and tick the box themselves. Human-checked and
  agent-checked boxes are equal; the flow is never 100% AI. The agent must state this when
  presenting the plan.

### 8. Setup follows ICM — the process itself is staged

Setup is not a monolith; it moves through stages, each producing a file, each a point where the
human can review, redirect, or take over:

| Stage | Does | Produces |
|-------|------|----------|
| 1. Kickoff + Interview | The two kickoff questions; the interview (or dictation) | `_setup/interview-notes.md` |
| 2. Plan | Design the workspace from the notes; present for review | `_setup/build-plan.md` |
| 3. Build | Execute the plan, one checkbox at a time | The workspace itself; boxes ticked |
| 4. Audit | Scan, verify against the ICM checklist, critique | `_setup/setup-review.md` |

All four stages are owned by **`_setup/AGENTS.md`** (Layer 2) — one stage file, because the
stages are sequential steps of a single job, not independent re-entrant pipelines. It carries
the prerequisite rule: each stage verifies the previous stage's file exists before working
(no plan without notes, no build without an approved plan, no audit until the plan's build boxes
are all ticked); missing → stop and report, never guess.

### 9. Scripts — any language, never without a help file *(decided 2026-07-04)*

The template takes **no position on scripting language** — PowerShell, Python, Bash, JavaScript,
anything: the workspace owner's choice, asked about in the interview (or defaulted to "none until
needed"). What is non-negotiable is documentation:

> **Every script created in the workspace — during setup or ever after — must be accompanied by
> a help file: `<script-name>.md` beside the script**, stating what it does, how to run it
> (with an example), what it needs (runtime, permissions, inputs), and what it touches.

This rule ships as **`reference/scripts-rule.md`** (Layer 3, standing, human-editable) and the
audit checks compliance. A script with no help file is a defect, not a style issue.

### 10. The audit — mandatory, objective, written down *(decided 2026-07-04)*

After **any** setup completes (guided or manual-then-resumed; also on explicit request against
an existing workspace), the agent runs an audit and writes **`_setup/setup-review.md`**:

- **Compliance scan**: walk the workspace against `reference/icm-checklist.md` — the shipped,
  human-editable definition of a well-formed ICM workspace (front-door chain present and in
  workspace mode; router rows all resolve; every stage folder has an `AGENTS.md`; reference
  files exist where stages cite them; input/output conventions consistent; every script has its
  help file; parent wiring done if it was requested). Each item: pass / fail / not applicable,
  with the fix for any fail.
- **Objective critique**: then step back and think critically, as a reviewer who did not build
  it — is the structure the *right* one for the problem in the interview notes, not just a
  compliant one? Flag over-engineering, missing stages, unclear ownership, risks, and open
  questions. Advice is labeled as advice; the human decides what to act on.
- The audit **never silently fixes** — it reports. Fixes happen only when the human says so
  (compliance fixes may be offered as a batch).

### 11. Standalone first; registration is opt-in *(decided 2026-07-04)*

The template is a **standalone artifact** — designed to be shared, dropped into any folder on
any machine, with no assumption that the surrounding workspace knows it exists. The underscore
in `_ICM-Template` marks it as scaffolding, not a project. Two registrations exist, both opt-in:

1. **Registering the template itself** with a host workspace: a README step — *if your workspace
   root has a `CONTEXT.md` router and you want "start a new ICM workspace" requests to land
   here, add a row (example given in the README).* Never done automatically by the template.
2. **Registering each new workspace** built from a copy: the kickoff question (requirement 5),
   default yes, executed as a build-plan step.

### 12. `_setup/` is the permanent record

After setup, `_setup/` stays: the interview notes, the fully-ticked build plan, and the audit
review are the workspace's birth certificate — why it is shaped the way it is. The new
workspace's rewritten `CONTEXT.md` routes "why is this workspace set up this way?" to
`_setup/`. Nothing in `_setup/` is deleted by the build (only `NEXT-STEPS.md` at the root is).
If the workspace is later reshaped substantially, a fresh interview/plan/audit cycle appends new
files (`build-plan-2.md`, …); old records are never rewritten.

### 13. Credits — the template carries its author *(decided 2026-07-04)*

The template is a shared, public artifact and must attach its author's name and links wherever
it travels:

- **`README.md` closes with a Credits section**:

  > Created by **Johnny Leuthard**
  > GitHub: <https://github.com/JohnnyLeuthard> — where this template lives
  > LinkedIn: <https://www.linkedin.com/in/johnnyleuthard/>

  GitHub is the primary link (the template's home); LinkedIn rides along as the professional
  contact. Keep it short — two or three lines, informational, never a barrier to use.
- **The shipped `_design/` seed carries the same credit** (in its `AGENTS.md`). Copies get
  renamed and their READMEs eventually rewritten into workspace docs, but `_design/` travels
  with every copy untouched — so attribution survives the copy becoming someone's workspace.
- Attribution is credit, not a license — licensing stays with the repository's `LICENSE.md`.
  Workspaces *built from* the template belong to their owners; the build never stamps the
  author's name into the new workspace's own files beyond what ships in `_design/`.

## Template Folder Structure

What `_ICM-Template/` contains when built (= what every fresh copy starts with):

```
_ICM-Template/
├── README.md                    ← human front door: the 9-step walkthrough; tour; registration; credits (req 1, 13)
├── NEXT-STEPS.md                ← "this copy is not set up yet" + the two paths; deleted when setup completes (req 2)
├── CLAUDE.md                    ← pointer to AGENTS.md (never changes)
├── AGENTS.md                    ← Layer 0, SEED MODE — rewritten into workspace mode by the build (req 3)
├── CONTEXT.md                   ← Layer 1, SEED MODE — routes setup → _setup/, explainers → docs/ (req 3)
│
├── docs/
│   ├── explain-icm.md           ← plain-language ICM explainer, self-contained (req 4)
│   └── explain-this-template.md ← how the template builds a workspace (req 4)
│
├── _setup/
│   ├── AGENTS.md                ← Layer 2: owns all four setup stages + prerequisite rules (req 8)
│   ├── interview-guide.md       ← Layer 3: question areas, stop-anytime rule, closing sweep (req 6)
│   └── (written during setup:)
│       interview-notes.md       ← everything the interview/dictation captured (req 6)
│       build-plan.md            ← the resumable checklist (req 7)
│       setup-review.md          ← the audit: compliance + critique (req 10)
│
├── reference/
│   ├── icm-checklist.md         ← what a well-formed ICM workspace must have; the audit's yardstick (req 10)
│   └── scripts-rule.md          ← every script gets a <name>.md help file; language is the owner's choice (req 9)
│
└── _design/                     ← this seed (CLAUDE/AGENTS/CONTEXT + SPEC + DECISIONS); ships with the
                                    template so every copy carries its own rebuild instructions
```

What a **finished workspace** looks like is *not* fixed here — that is the interview's and the
plan's job. The checklist in `reference/icm-checklist.md` defines the invariants (chain, router,
staged `AGENTS.md` files, reference material, input/output separation); the shape between those
invariants is per-workspace.

## Flow Summary

1. Human copies `_ICM-Template/` to the destination, renames it to the workspace name, points an
   agent at it ("set up this workspace").
2. Seed-mode chain routes to `_setup/AGENTS.md`. Kickoff: interview or manual? wire into parent
   (default yes)? Manual → the human works from `NEXT-STEPS.md`; the agent stands by.
3. Interview: one question at a time, exit offered every question, agent may call "enough,"
   closing sweep — all captured to `_setup/interview-notes.md`.
4. Plan: agent designs the workspace and writes `_setup/build-plan.md` (structure tree + every
   step as a checkbox + audit as the last box). Human reviews, edits freely, says go.
5. Build: execute checkbox by checkbox, ticking each immediately. Human may do any step by hand
   and tick it. Interrupted? Any later session reads the plan, cross-checks disk, resumes at the
   first unchecked box. Build includes: the structure, the front-door rewrite to workspace mode,
   parent wiring (if yes), and deleting `NEXT-STEPS.md`.
6. Audit: compliance scan against `reference/icm-checklist.md` + objective critique →
   `_setup/setup-review.md`. Report to the human: what passed, what failed, what I'd worry
   about. Fixes only on the human's say-so.
7. `_setup/` remains as the permanent record of the workspace's birth.

## Build & Integration Protocol *(for building `_ICM-Template/` from this seed)*

Follow this when asked to build (or rebuild) the template from `_design/`.

### Where to build

1. **`_design/` sits inside the template folder** (its parent is `_ICM-Template/` or a renamed
   copy — empty, partial, or complete): build into the parent folder.
2. **`_design/` was dropped directly into a workspace root**: create `_ICM-Template/` beside it,
   **move `_design/` inside it**, then build as in case 1.

### What to build

Everything in the Template Folder Structure section except the three "written during setup"
files (`interview-notes.md`, `build-plan.md`, `setup-review.md` — those are produced per-copy by
setup, never shipped). Where this spec pins behavior (kickoff questions, interview rules,
checklist protocol, audit duties), write files that implement it; where it pins tone (the
`docs/` explainers follow the teaching lab's `explain-it-to-me.md` style: friendly,
analogy-first, no jargon assumed), match it.

### Preservation rule (rebuilds)

A rebuild restores shipped machine files but never clobbers evidence of use: any
`interview-notes.md`, `build-plan.md`, or `setup-review.md` found in `_setup/`, and any file the
human customized (a shipped file that differs from spec gets a confirmation before overwrite).
If the front-door chain is found in **workspace mode** — this copy already became a real
workspace — stop and ask before touching anything: rebuilding seed files inside a live workspace
is almost never what the human wants.

### Registering the template (optional)

The template is standalone by default (requirement 11). After building, if the parent workspace
has a `CONTEXT.md` router **and the human confirms**, add a row routing "starting a new ICM
workspace / new project from template" to `_ICM-Template/`. Follow the router's own row
conventions; replace any row that points at `_design/` as "not built yet". Report exactly what
was changed, or that nothing was.

### Verify

Structural — a real setup run needs a human in the interview, so no unattended end-to-end test:

- Every file in the Template Folder Structure exists (minus the three per-copy setup outputs);
  no extras beyond `_design/`.
- `CLAUDE.md` is the standard pointer; `AGENTS.md` and `CONTEXT.md` are in seed mode and say so.
- Seed `CONTEXT.md` routes: setup → `_setup/AGENTS.md`; explainers → `docs/`; premature work
  requests → the polite stop.
- `_setup/AGENTS.md` covers all four stages, both kickoff questions, the checkbox protocol
  (immediate ticking, resumption rule, human-may-tick), and the prerequisite rules.
- `interview-guide.md` includes the stop-anytime rule and the closing sweep.
- `README.md` and `NEXT-STEPS.md` address the human, not the agent; `NEXT-STEPS.md` includes
  the delete-me-if-manual note.
- `README.md` contains the full nine-step walkthrough (requirement 1) and closes with the
  Credits section (requirement 13, both links); the `_design/AGENTS.md` credit line is present.
- The two `reference/` files exist; `icm-checklist.md` items are checkable (each one is a
  yes/no question against the filesystem).
- Then walk the human through `README.md` and offer a dry-run of the kickoff questions — do not
  run a real setup unless asked.

## Out of Scope (for v1)

- **Pattern presets** (shipped pipeline/fan-out skeletons to choose from) — the interview + plan
  designs the shape instead; presets can be added later as `docs/` examples if wanted.
- **Automatic updates of copies** when the template changes — copies are independent once made.
- **Cross-workspace features** (shared reference libraries, workspace-to-workspace routing) —
  per the root rule, no cross-loading between projects.
- **Harness-specific machinery** (subagents, hooks, MCP) — the template must work with any agent
  that can read files; anything harness-specific belongs to the individual workspace after
  setup, never to the template.
