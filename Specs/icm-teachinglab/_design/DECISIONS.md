# ICM Teaching Lab — Decision Log

Append-only. Each entry: what was decided, why, and what was rejected. The spec
(`SPEC.md`) records outcomes; this file records reasoning. Never rewrite old
entries — supersede them with new ones.

All entries below: **2026-07-03**. The lab was built before this log existed, so
D1–D9 are retro-documented from the as-built structure; D10–D13 were made the day
the `_design/` folder was created.

---

## D1. Purpose: a teaching lab, not a production workflow

**Why**: The step after `hello-world` — prove *why* folder-following matters, not
just *that* it works. The announcement workflow is deliberately small and slightly
artificial; the visible, inspectable process is the deliverable.
**Rejected**: Starting with a real production workflow — too much domain noise to
teach the pattern.

## D2. Pipeline pattern: four numbered stages

**Why**: Brief → draft → review → final is the smallest realistic workflow that
exercises every ICM element (routing, staged context, references, guards, a loop).
Numbered folder names make the order self-evident to humans and agents alike — the
names *are* the process diagram.
**Rejected**: Fewer stages (loses the review loop, the most instructive part);
unnumbered names (order would need explaining somewhere else).

## D3. Front-door chain: CLAUDE.md → AGENTS.md → CONTEXT.md

**Why**: `CLAUDE.md` is what the harness auto-loads, so it exists only to redirect;
`AGENTS.md` holds identity ("where am I") harness-neutrally; `CONTEXT.md` holds
routing ("where do I go"). Splitting identity from routing keeps each file one job.
This is the workspace-wide convention every project follows.
**Rejected**: One combined file (identity and routing change at different rates);
putting real content in CLAUDE.md (ties the lab to one harness).

## D4. One shared `output/` folder, not per-stage outputs

**Why**: Both are valid Layer 4 layouts (the ICM whitepaper's example tree shows
per-stage outputs). At this size, a shared folder keeps cross-stage reads simple —
stage 3 reads the brief and the draft from one place.
**Rejected**: Per-stage `output/` folders — better for large workflows with many
artifacts per stage; overhead here.

## D5. Per-job folders with names derived from the input filename

**Why**: Multiple jobs must coexist without overwriting each other. Deriving the
job name from `raw-request-<job>.md` means no registry to maintain — the filename
is the registration. Rules live once in `reference/naming-convention.md`; every
stage points at it instead of restating them.
**Superseded**: The original flat layout (`output/brief.md`, one job at a time),
which the first real second job broke.

## D6. Prerequisite guards: check upstream, run the earlier stage if missing

**Why**: A stage working from an empty or missing input produces confident garbage.
Each stage verifies its upstream artifact and backs up one stage instead —
self-healing for the common case. Stage 2's explicit Prerequisites table doubles as
a teaching artifact: who sets each precondition, and whether it is per-run or
standing.
**Rejected**: Always stop and ask the human (babysitting for something the chain
can fix itself).

## D7. Review loop bounded at one iteration

**Why**: "Ready For Final: no" sends the work back to stage 2 exactly once, then
the pipeline proceeds regardless. Demonstrates a loop without risking an unbounded
one — the same instinct as the debate lab's max-rounds backstop.
**Rejected**: Loop until pass (no termination guarantee); no loop (review becomes
advisory theater).

## D8. Reference files hold only reusable rules; job specifics live in the brief

**Why**: `style-guide.md` and `quality-bar.md` must work unchanged for a different
input — that is what makes editing them the standing way to change behavior.
Anything request-specific (audience, required points) belongs in the brief. This
split is the lab's core lesson: change the system by editing a rulebook, never by
rewriting stage logic.

## D9. Human-only folders: `docs/`, `README.md`, `_tmp/`

**Why**: The lab teaches people, so it carries prose the agent never needs —
kept out of the agent's read paths so it costs nothing at runtime. Underscore
prefix (`_tmp/`, `_design/`) marks non-system folders.

## D10. Design docs: SPEC.md + DECISIONS.md, retro-documented

**Why**: Adopt the debate-lab convention (its D23): two docs per project, no more.
The lab predates the convention, so the spec is written *from* the as-built
structure — the running lab is the source of truth, and the spec now makes it
rebuildable. Decision logs preserve reasoning that otherwise lives only in chat
history.
**Rejected**: Leaving the lab undocumented (can't be rebuilt or seeded elsewhere);
a single design doc (outcomes and reasoning change at different rates).

## D11. `_design/` carries its own CLAUDE.md → AGENTS.md → CONTEXT.md seed chain

**Why**: The goal is drop-in portability: copy `_design/` into any workspace, say
"build it out," and the agent self-orients with no other context. That requires
the folder to be a complete ICM workspace in miniature — identity, router, and the
spec as its Layer 2/3 content. This is the one thing the debate-lab `_design/`
does not have (yet).
**Rejected**: Bare SPEC+DECISIONS only (requires the surrounding workspace to
explain what the folder is — exactly what a drop-in can't assume).

## D12. The builder plugs the lab into the parent workspace

**Why**: A drop-in that builds but doesn't register leaves the human hand-wiring
routers. The spec's Build & Integration Protocol makes integration part of the
build: add a router row if the parent has a `CONTEXT.md`, add a pointer if it only
has `CLAUDE.md`/`AGENTS.md`, stand alone if there is no parent chain — and always
report which parent files changed. Mirrors the workspace root's own rule ("new
projects update the router"), executed from the child's side.
**Rejected**: Build-only seed (manual wiring defeats "drop it in and ask");
unconditionally creating a workspace root chain (invasive in a workspace that
organizes itself differently).

## D13. Rebuilds preserve human material

**Why**: A rebuild restores the machine files (front-door chain, stages,
references) from the scaffolds but never clobbers what the human made: real
inputs, `output/` job folders, `docs/`, README edits. Outputs are the record —
same instinct as the debate lab's never-delete rule. Any machine file that exists
but differs from its scaffold gets a confirmation before overwrite, since the
human may have customized it deliberately.
**Rejected**: Clean-slate rebuild (destroys the record and human customizations).
