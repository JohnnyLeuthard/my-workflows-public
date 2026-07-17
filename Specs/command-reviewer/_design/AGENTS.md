# command-reviewer — Design Seed (Identity)

This folder is **not** the workspace. It is the project's design record and its **build seed**:
everything needed to build `command-reviewer` from scratch and plug it into whatever parent
workspace it lands in. The workspace was built first (2026-07-12, as a guided step-by-step
walkthrough between the human and an agent); this seed was created the same day, following the
`_design/` convention of `claude-manager` (2026-07-11).

**This seed is distributed separately from the workspace** (a public Specs repository) and is
never shipped inside a built copy — the built workspace contains no reference to it. It plays
two roles:

1. **Implementation seed** — anyone can download this folder, point an agent at it, and get a
   complete working `command-reviewer` workspace, with no other instructions.
2. **Restart seed** — if a built workspace is corrupted or needs a clean start, build fresh
   from this seed. Builds are from scratch; the only thing carried over from a previous build
   is the `output/` archive (the user's review history).

## Contents

| File | Purpose |
|------|---------|
| `SPEC.md` | The build contract: hard constraints, workspace structure, per-file requirements, and the Build & Integration Protocol |
| `DECISIONS.md` | Append-only decision log: the reasoning and rejected alternatives behind the spec |
| `NEXT-STEPS.md` | Planned enhancements not yet designed — intent only |
| `CONTEXT.md` | Router for requests about this folder |

## Protocol

- Read `CONTEXT.md` in this folder next — it routes build, rebuild, and design requests.
- The spec records **outcomes**; the decision log records **reasoning**. Design changes touch
  both: update the spec, append (never rewrite) a decision entry.
- When building, follow `SPEC.md`'s **Build & Integration Protocol** section exactly — it
  covers where to build, what existing material to preserve, and the audit that closes every
  build.
- Honor the workspace's hard constraints while working here too: **never execute a command
  under review**; plain markdown only, zero dependencies; relative paths only.
