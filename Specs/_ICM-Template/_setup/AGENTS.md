# Setup — Stage Instructions (Layer 2)

You are setting up a fresh copy of the ICM Workspace Template into a real workspace. Setup runs
in **four sequential stages**, each producing a file in this folder. The files are the state —
never rely on session memory for anything a later session might need.

**Before anything else — two checks:**

- **Master-copy guard**: if this workspace's folder is still named `_ICM-Template`, stop. This
  is the template master; setup runs only on renamed copies. Tell the human to copy and rename
  first (`README.md` steps 1–3).
- **Resume check**: if `_setup/build-plan.md` exists with unchecked boxes, this is a resumed
  setup — skip to Stage 3's resumption rule. If it exists fully ticked but
  `_setup/setup-review.md` is missing, run Stage 4. If both are complete, setup is done —
  report that and route the request through the workspace's front door instead.

**Prerequisite rule (all stages)**: each stage verifies the previous stage's file exists before
working — no plan without notes, no build without a reviewed plan, no audit until every build
box is ticked. Missing prerequisite → stop and report; never write from a guess.

**The human can take the reins at any point.** They may stop the interview, edit any file
directly, perform build steps by hand and tick the boxes, or take over entirely. Human edits
and human-ticked boxes are equal to your own. Say this out loud at Stage 2 — the option must be
known to be real.

---

## Stage 1 — Kickoff + Interview → `interview-notes.md`

Ask the human exactly two kickoff questions before any other work:

1. **Interview or manual?** *"Want a short interview so I understand what this workspace is
   for — or would you rather tell me directly, or build it yourself?"* Recommend the
   interview; never force it. If fully manual: point the human at `NEXT-STEPS.md` and stand
   by — your only further duty is the audit if asked (Stage 4 can run against a manual build).
2. **Wire into the parent? (default: yes)** Check whether the parent folder has an ICM chain
   (`CONTEXT.md` router, or `CLAUDE.md`/`AGENTS.md` without one). If yes, offer to register
   the new workspace there when the build completes — default yes. If no chain exists, say so
   and skip the question; the workspace stands alone.

Then run the interview per [interview-guide.md](interview-guide.md). Non-negotiable mechanics
(the guide's question areas are editable; these rules are not):

- One question at a time, conversational, adapted to prior answers — not a form.
- **State up front and honor at every question**: the human can stop whenever they want
  ("enough questions" / "just build it").
- You may also call it: when you have enough to design the workspace, say so and offer to stop.
- **Closing sweep, always**: before concluding — however the interview ends — ask *"anything
  important I haven't asked about?"*
- Write everything captured to `_setup/interview-notes.md`: organized by topic, in the human's
  own terms, including the two kickoff answers. If the interview was skipped or dictated,
  write the file anyway with what was given, marked as dictated. Invite the human to edit the
  file directly before Stage 2.

## Stage 2 — Plan → `build-plan.md`

*Prerequisite: `interview-notes.md` exists.*

Design the workspace from the notes and write `_setup/build-plan.md`:

1. **Header**: the kickoff answers (interview taken or dictated; parent wiring yes/no and
   where).
2. **Intended structure**: a folder tree of the finished workspace, one line of purpose per
   entry. Design for the problem in the notes — the ICM invariants
   ([../reference/icm-checklist.md](../reference/icm-checklist.md)) are the frame; the shape
   inside them (stages, fan-out, single flow) should fit the work, as simple as the problem
   allows.
3. **Build steps as checkboxes** (`- [ ]`), one per concrete action, in build order. Must
   include, late in the list: rewriting `AGENTS.md` and `CONTEXT.md` from seed mode into the
   real workspace identity and router (`CLAUDE.md` never changes); parent wiring (if yes) —
   a router row per the parent's own conventions, or an `AGENTS.md` pointer if it has no
   router; deleting `NEXT-STEPS.md`; and **the audit (Stage 4) as the always-last box**.
4. If any scripts are planned: each script step includes its `<script-name>.md` help file per
   [../reference/scripts-rule.md](../reference/scripts-rule.md) — one box covers both, since
   neither ships without the other.

Present the plan to the human for review. Tell them: edit it freely — strike, add, reorder —
your edits are the approval; and you can do any step yourself and tick the box. Do not tick
anything until the human says go.

## Stage 3 — Build (tick as you go)

*Prerequisite: `build-plan.md` exists and the human has said go.*

- Execute one checkbox at a time, in order. Tick each box (`- [x]`) **immediately** after its
  step completes — never in batches. An interruption must never cost more than one step.
- **Resumption rule** (entering here on a resumed setup): read the plan first, then cross-check
  every box against disk — a **ticked** box whose artifact is missing gets unticked and redone;
  an **unticked** box whose artifact already exists (a human did it, or a tick was lost) gets
  verified and ticked. Then continue from the first unticked box. Never redo verified work.
- The front-door rewrite must leave no seed-mode text behind: the new `AGENTS.md` states the
  workspace's real identity; the new `CONTEXT.md` routes the workspace's real work, includes a
  row sending "why is this workspace set up this way?" to `_setup/`, and keeps the standing
  reference rules reachable.
- Report exactly what was changed outside this workspace (the parent wiring), or that nothing
  was.

## Stage 4 — Audit → `setup-review.md`

*Prerequisite: every Stage-3 box in `build-plan.md` is ticked (the audit box itself excepted).
Also runnable on explicit request against a manually built workspace.*

Write `_setup/setup-review.md` with two distinct parts:

1. **Compliance scan**: walk the workspace against
   [../reference/icm-checklist.md](../reference/icm-checklist.md), item by item — **pass /
   fail / n-a**, with the concrete fix for every fail.
2. **Objective critique**: step back and review as someone who did *not* build it. Judge the
   structure against the problem in `interview-notes.md` — right shape, or merely compliant?
   Flag over-engineering, missing stages, unclear ownership, risks, open questions. Label
   advice as advice.

**Never silently fix.** Report; offer compliance fixes as a batch; act only on the human's
say-so. Then tick the final box, confirm `NEXT-STEPS.md` is gone, and tell the human where
everything landed.

---

*After setup, this folder stays put: `interview-notes.md`, the fully-ticked `build-plan.md`,
and `setup-review.md` are the workspace's permanent record. Never delete them. A later
substantial reshape appends new files (`build-plan-2.md`, …) — old records are never
rewritten.*
