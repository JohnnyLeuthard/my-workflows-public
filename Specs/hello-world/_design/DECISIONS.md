# Hello-World — Decision Log

Append-only. Each entry: what was decided, why, and what was rejected. The spec
(`SPEC.md`) records outcomes; this file records reasoning. Never rewrite old
entries — supersede them with new ones.

All entries below: **2026-07-03**. The lab was built before this log existed, so
D1–D6 are retro-documented from the as-built structure; D7–D10 were made the day
the `_design/` folder was created.

---

## D1. Purpose: the smallest possible proof that folders can control an agent

**Why**: Before any realistic workflow, prove the mechanism in isolation: an agent
enters a folder, follows markdown instruction files hop by hop, looks facts up in
a reference file, and leaves a visible artifact. Adapted from Jake Van Clief's
video demo (linked in the lab's README). Everything else in the workspace builds
on this proof.
**Rejected**: Starting with a realistic workflow (that is the teaching lab's job —
mixing "does the mechanism work" with "is the workflow useful" muddies both).

## D2. The output spells the lesson: CONTROL YOUR AGENT

**Why**: The folder names (`01-control`, `02-your`, `03-agent`) spell the phrase
the demo writes — the exercise is its own message, and a class remembers a
punchline. Numbered prefixes make the order self-evident.

## D3. Stages never state their word — they look it up in `skills/SKILLS.md`

**Why**: The indirection is the entire teaching point: instructions (stages) are
separate from knowledge (skills). It enables the live-demo encore — edit one word
in the reference file, rerun, and the output changes with no stage edits.
**Rejected**: Hard-coding each word in its stage file (three hops with nothing to
teach — no separation of instruction from knowledge).

## D4. `skills/` vocabulary here; `reference/` in the larger labs

**Why**: This demo keeps the ICM whitepaper's "skills" term for its knowledge
layer, staying close to the source material it teaches from. The larger labs use
`reference/` for the same layer. Same layer, two names — the contrast is itself
worth a sentence in class.

## D5. One shared output file, shipped empty

**Why**: A single `output/power.md` keeps the demo one-glance simple, and shipping
it empty gives the class a visible before/after. Reset is one action: empty the
file. Unlike the other labs, this output is disposable by design — no per-job
folders, no record to preserve.
**Rejected**: Per-stage or per-job outputs (machinery with nothing to demonstrate
at this size).

## D6. Ultra-minimal front door: AGENTS.md is one line

**Why**: At three hops, identity and kickoff are the same sentence — "read the
router, start at stage 1." A layered identity file would be longer than the lab.
The full Layer 0/1 split is demonstrated where it earns its size (the teaching
lab).

## D7. Design docs: SPEC.md + DECISIONS.md, retro-documented

**Why**: Adopt the workspace convention (debate-lab D23, teaching-lab D10): two
docs per project, no more. The lab predates the convention, so the spec is written
*from* the as-built structure — and because every file is tiny, the spec carries
all of them verbatim, making it a complete, self-sufficient rebuild kit.
**Rejected**: Leaving it undocumented (the whole point is handing someone the spec
and getting a working class demo back).

## D8. `_design/` carries its own CLAUDE.md → AGENTS.md → CONTEXT.md seed chain

**Why**: Same as teaching-lab D11 / debate-lab D24: drop-in portability requires
the folder to be an ICM workspace in miniature — an agent landing in it cold can
orient, build, and integrate with no other context.
**Rejected**: Bare SPEC+DECISIONS (assumes surrounding context a drop-in can't
assume).

## D9. Integration walks EVERY level up the chain, at any depth

**Why**: The seed must be independent of any particular parent — this lab
historically sat inside a container folder (`iScaleLabs/`), and the next copy
might sit one level deep or four. So the protocol generalizes the parent-update
rule: walk upward level by level to the workspace root; at each level add a
router row (if a `CONTEXT.md` exists), or a pointer (if only `CLAUDE.md`/
`AGENTS.md`), or skip (if the level has no chain files — routers above may link
down through it with deeper relative paths). Add-only, report every file touched.
**Rejected**: Updating only the immediate parent (breaks routing from the top when
the lab is nested); creating chain files in bare intermediate folders (invasive —
deep links from upper routers work fine without them).

## D10. Verify end to end, then reset

**Why**: Unlike the debate lab (human checkpoints) and unlike the teaching lab's
kept outputs, this demo can and should be fully verified by running it — then
**reset** (`output/power.md` emptied) so the class sees the before/after live. A
demo that arrives pre-run has already spent its punchline.
**Rejected**: Structural checks only (a one-minute run is cheaper than the doubt);
leaving the verified output in place (spoils the demo).
