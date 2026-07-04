# ICM Workspace Checklist (Layer 3 — human-editable)

What a well-formed ICM workspace must have. Every item is a **yes/no question answerable by
looking at the filesystem** — no vibes. This is the setup audit's yardstick, the target for
anyone building manually, and fair game for re-running against a workspace any time.

Verdict per item: **pass / fail / n-a** (n-a needs a stated reason).

## The Front Door

- [ ] `CLAUDE.md` exists and is the standard one-line pointer to `AGENTS.md`.
- [ ] `AGENTS.md` exists, states *this* workspace's identity (what it is, what it's for, ground
      rules) — no seed-mode or placeholder text remains.
- [ ] `CONTEXT.md` exists with a routing table; it covers the workspace's actual kinds of
      requests.
- [ ] Every route in `CONTEXT.md` resolves — each target file/folder exists.
- [ ] `CONTEXT.md` routes "why is this workspace set up this way?" (or equivalent) to the
      `_setup/` record, if one exists.

## Stages

- [ ] Every stage folder contains an `AGENTS.md` saying what it reads, does, and writes.
- [ ] Every stage's `AGENTS.md` names its prerequisite (what must exist before it works) and
      says to stop-and-report when the prerequisite is missing.
- [ ] Every file a stage cites (reference files, inputs, upstream outputs) exists or is
      produced by an earlier stage.
- [ ] No stage folder is unreachable — each is routed to by `CONTEXT.md` or invoked by another
      stage.

## Rules and Materials

- [ ] Standing rules live in `reference/` (or the workspace's declared equivalent), separate
      from stage logic.
- [ ] Work materials and results are separated from instructions (e.g. `input/` / `output/` or
      the workspace's declared equivalent), and the convention is stated somewhere findable.
- [ ] Scaffolding folders (`_template/`, `_design/`, `_setup/`, `_tmp/`…) are underscore-marked
      and never routed to as work stages.

## Scripts

- [ ] Every script in the workspace has a `<script-name>.md` help file beside it, per
      [scripts-rule.md](scripts-rule.md).

## Setup Closure (workspaces built from the template)

- [ ] `NEXT-STEPS.md` is absent.
- [ ] `_setup/` contains `interview-notes.md`, a fully-ticked `build-plan.md`, and
      `setup-review.md`.
- [ ] If parent wiring was requested: the parent's router (or `AGENTS.md`) references this
      workspace, and the reference resolves.
