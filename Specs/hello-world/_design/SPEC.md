# Hello-World — Build Spec

**Status**: Retro-documented from the as-built lab (2026-07-03). The lab was built first (from the
video linked in its README) and this spec was written from it, so a rebuild from this file alone
reproduces the working structure. `DECISIONS.md` alongside this file records the reasoning.

**This folder is also a drop-in build seed**: copy `_design/` anywhere — any workspace, any depth
— and ask the agent to build it out. The **Build & Integration Protocol** section at the end tells
the builder where to build and how to wire the lab into **every** `CLAUDE.md` / `AGENTS.md` /
`CONTEXT.md` up the chain, so it plugs in wherever it is placed.

---

## Goal

Build the smallest possible working demonstration of Interpretable Context Methodology (ICM),
also called Model Workspace Protocol (MWP): an agent enters a folder, follows a chain of markdown
instruction files through three numbered stages, looks facts up in a reference file, and writes a
visible output — proving that **folder structure alone can control an agent**, with no code and
no framework.

The demo writes three words — `CONTROL YOUR AGENT` — one word per stage, into a single output
file. The punchline is the phrase itself: the folder names spell it (`01-control`, `02-your`,
`03-agent`), and the exercise *is* its own message.

This is a **class demo**: it must run end to end in under a minute, be fully inspectable by an
audience with no technical background, and be resettable between runs.

## Core Requirements

### 1. Front-door chain

- `CLAUDE.md` — one line, redirects to `AGENTS.md` (the harness auto-loads this filename).
- `AGENTS.md` — one line: read `CONTEXT.md`, then go to `01-control/` and follow its
  instructions. Deliberately minimal — at this size, identity and kickoff are the same sentence.
- `CONTEXT.md` — the router: what the tutorial is, a three-row routing table (one per stage),
  and pointers to the reference file and the output file.
- `README.md` — for humans: credits the source video the lab came from.

### 2. Three numbered stages, one instruction each

Each stage folder contains exactly one `AGENTS.md` with exactly one job and a handoff:

| Stage | Writes | Then |
|-------|--------|------|
| `01-control/` | the **first** word into `../output/power.md` | read `../02-your/AGENTS.md` and follow it |
| `02-your/` | the **second** word into `../output/power.md` | read `../03-agent/AGENTS.md` and follow it |
| `03-agent/` | the **third** word into `../output/power.md` | say **DONE, BOSS!!!** |

No stage states its word — every stage looks its word up in `../skills/SKILLS.md`. That
indirection is the teaching point: instructions (stages) are separate from knowledge (skills),
and changing the reference file changes the output without touching any stage.

### 3. Reference: `skills/SKILLS.md`

One file declaring the three words (first = CONTROL, second = YOUR, third = AGENT). Named
`skills/` — this demo uses the ICM whitepaper's "skills" vocabulary for its reference layer;
the larger labs use `reference/`. Editing this file is the live-demo trick: change a word,
rerun, and the output changes with no stage edits.

### 4. Output: `output/power.md`

One shared output file. **Ships empty** — the demo's before/after is the proof. The three stages
append/assemble the phrase so the finished file reads `CONTROL YOUR AGENT`.

### 5. Resettable for a class

Resetting the demo is one action: empty `output/power.md`. Nothing else holds state.

## Folder Structure

```
hello-world/
├── CLAUDE.md              ← pointer to AGENTS.md
├── AGENTS.md              ← one line: read CONTEXT.md, start at 01-control/
├── CONTEXT.md             ← router: the three stages, reference, output
├── README.md              ← human note: source video credit
│
├── 01-control/AGENTS.md   ← write word 1 (from skills), hand off to 02
├── 02-your/AGENTS.md      ← write word 2 (from skills), hand off to 03
├── 03-agent/AGENTS.md     ← write word 3 (from skills), say DONE, BOSS!!!
│
├── skills/SKILLS.md       ← the three words (the only "knowledge" in the lab)
├── output/power.md        ← ships empty; ends up reading CONTROL YOUR AGENT
└── _design/               ← this folder: seed chain + SPEC.md + DECISIONS.md; not part of the run
```

## Flow Summary

1. Human says "run the hello-world tutorial" (from the lab folder, or routed in from any level
   above it).
2. `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` → `01-control/AGENTS.md`.
3. Stage 1 looks up the first word in `skills/SKILLS.md`, writes it to `output/power.md`, and
   reads stage 2's instructions. Stages 2 and 3 repeat the pattern for their words.
4. Stage 3 finishes and the agent says **DONE, BOSS!!!** — `output/power.md` now reads
   `CONTROL YOUR AGENT`.

## File Scaffolds

The exact contents of every file, verbatim. A rebuild copies these as-is.

### `CLAUDE.md`

````markdown
Read the AGENTS.md file in this same folder and follow instructions
````

### `AGENTS.md`

````markdown
Read `CONTEXT.md` in this folder, then go to the `01-control` sub-folder, read its `AGENTS.md`, and follow the instructions.
````

### `CONTEXT.md`

````markdown
# hello-world - Router

A three-stage tutorial (from the video linked in `README.md`). The stages run in order and write their
result to `output/power.md`.

| If the request involves... | Route to... |
|----------------------------|-------------|
| Running the tutorial, the first word | [01-control/AGENTS.md](01-control/AGENTS.md) |
| The second word | [02-your/AGENTS.md](02-your/AGENTS.md) |
| The third word, finishing | [03-agent/AGENTS.md](03-agent/AGENTS.md) |
| Rebuilding the lab, design questions | [_design/CLAUDE.md](_design/CLAUDE.md) |

Reference: `skills/SKILLS.md` holds the words each stage looks up. Output: `output/power.md`.
````

### `README.md`

````markdown
Video this came from:

https://youtu.be/KPVaUuBkPz8?is=gQu5omoeM9oVGI3g
````

### `01-control/AGENTS.md`

````markdown
You are going to write the first word in the file `../output/power.md`.

The first word is found in `../skills/SKILLS.md`.

After that, read `../02-your/AGENTS.md` and follow its instructions.
````

### `02-your/AGENTS.md`

````markdown
You are going to write the second word in the file `../output/power.md`.

The second word is found in `../skills/SKILLS.md`.

After that, read `../03-agent/AGENTS.md` and follow its instructions.
````

### `03-agent/AGENTS.md`

````markdown
You are going to write the third word in the file `../output/power.md`.

The third word is found in `../skills/SKILLS.md`.

After you are done, just say DONE, BOSS!!!
````

### `skills/SKILLS.md`

````markdown
when asked for the first word, the first word is always CONTROL

when asked for the second word, the word is always YOUR

when asked for the third word, the word is always AGENT
````

### `output/power.md`

Create it **empty** (a blank file). The demo fills it.

## Build & Integration Protocol *(for building from this seed)*

Follow this when asked to build (or rebuild) the lab from `_design/`. The seed is independent of
any particular parent — it must plug in wherever it is placed, at any depth.

### Where to build

1. **`_design/` sits inside a project folder** (its parent is the lab folder itself — empty,
   partial, or complete): build into the parent folder. Missing files are created from the
   scaffolds. Confirm before overwriting any file that differs from its scaffold — the human may
   have customized it (e.g. changed the words in `skills/SKILLS.md`).
2. **`_design/` was dropped anywhere else** (a workspace root, a labs folder, any container):
   create `hello-world/` beside it, **move `_design/` inside it**, then build as in case 1.

### Plugging in — update every MD up the chain

After building, walk **upward from the lab's parent, level by level, until the workspace root**
(the git root, or the topmost folder that carries a `CLAUDE.md`/`AGENTS.md`/`CONTEXT.md` chain —
whichever comes first). The lab may sit one level deep or four; the walk is the same. At **each**
level:

1. **The level has a `CONTEXT.md` router**: add a routing row for the tutorial if one is not
   already there (e.g. *"Hello-world tutorial, smallest ICM demo → <relative-path>/hello-world/CLAUDE.md"*),
   using a relative path from that level and following that router's own row conventions.
2. **The level has `CLAUDE.md`/`AGENTS.md` but no router**: add a short pointer to the lab where
   that level lists its contents, matching its existing style.
3. **The level has no chain files at all**: skip it — a router above can point down through it
   with a deeper relative path (routers may link deep; intermediate folders need no files).

Never remove or rewrite existing rows; only add. When the walk is done, routing works from the
very top: a request at the workspace root reaches the tutorial through every router in between.
Always report exactly which files at which levels were changed (or that none needed changing).

If there is no chain anywhere above, the lab stands alone — its own `CLAUDE.md` is the entry
point. Offer to create a minimal root chain, but do not create one unasked.

### Verify — then reset for the class

This lab has no human checkpoint, so verify end to end:

1. Run the tutorial: follow `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` → the three stages.
2. Confirm `output/power.md` reads `CONTROL YOUR AGENT` and the run ended with **DONE, BOSS!!!**.
3. **Reset**: empty `output/power.md` again, so the class demo starts fresh with a visible
   before/after.
4. Report ready, and include the one-line demo prompt: *"Run the hello-world tutorial."*

## Class Demo Notes

- **Run time**: under a minute. **Setup**: none beyond the build. **Reset between runs**: empty
  `output/power.md`.
- **The arc to show the audience**: (1) the empty output file, (2) the one-line prompt, (3) the
  agent visibly hopping folder to folder, (4) the filled output file and the DONE, BOSS!!! sign-off.
- **The encore**: edit one word in `skills/SKILLS.md` in front of the class, reset, rerun — the
  output changes with no stage edits. That is the whole ICM argument in one move: instructions,
  knowledge, and output are separate files, and editing a text file reprograms the system.
- **Where to go next**: the ICM Teaching Lab (brief → draft → review → final) is the same pattern
  at realistic size; its own `_design/` seed builds it the same way.

## Out of Scope

- Inputs, per-job outputs, guards, loops, review — that is the teaching lab's job. This demo
  stays three hops and one file on purpose: small enough to hold in one screenful, complete
  enough to prove the point.
