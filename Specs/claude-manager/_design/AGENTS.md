# Claude Manager — Design Seed (Identity)

This folder is **not** the tool. It is the project's design record and its **build seed**:
everything needed to build `claude-manager` from scratch and plug it into whatever workspace
it lands in. The project was built first (2026-05 → 2026-07); this seed was created
**2026-07-11** to adopt the workspace's `_design/` convention, absorbing and superseding the
old root `SPEC.md`.

It plays two roles:

1. **Design record** — it documents what was decided and why, and it is the reference for
   rebuilding or repairing the project.
2. **Drop-in seed** — copied on its own into any workspace, it carries enough context that an
   agent told to "build it out" can construct the entire project and register it with the
   parent workspace, with no other instructions.

## Contents

| File | Purpose |
|------|---------|
| `SPEC.md` | The build contract: constraints, structure, per-script requirements, security model, and the Build & Integration Protocol |
| `DECISIONS.md` | Append-only decision log: the reasoning and rejected alternatives behind the spec |
| `NEXT-STEPS.md` | Planned enhancements not yet designed — intent only |
| `CONTEXT.md` | Router for requests about this folder |

## Protocol

- Read `CONTEXT.md` in this folder next — it routes build, rebuild, and design requests.
- The spec records **outcomes**; the decision log records **reasoning**. Design changes touch
  both: update the spec, append (never rewrite) a decision entry.
- When building, follow `SPEC.md`'s **Build & Integration Protocol** section exactly — it
  covers where to build, what existing material to preserve, verification (including the
  fixture flow and the server-hardening checks), and how to register with a parent workspace.
- Honor the project's hard constraints while working here too: zero npm dependencies, no
  writes outside the repo, nothing real from `~/.claude` in tracked files.
