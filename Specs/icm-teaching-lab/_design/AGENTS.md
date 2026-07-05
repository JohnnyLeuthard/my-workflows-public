# ICM Teaching Lab — Design Seed (Identity)

This folder is **not** the teaching lab. It is the lab's design record and its **build seed**:
everything needed to (re)build the ICM Teaching Lab from scratch and plug it into whatever
workspace it lands in.

It plays two roles:

1. **Design record** — when it sits inside a built `icm-teaching-lab/`, it documents what was
   decided and why, and is the reference for rebuilding or repairing the lab.
2. **Drop-in seed** — copied on its own into any workspace, it carries enough context that an
   agent told to "build it out" can construct the entire lab and register it with the parent
   workspace, with no other instructions.

## Contents

| File | Purpose |
|------|---------|
| `SPEC.md` | The build contract: requirements, folder structure, verbatim file scaffolds, and the Build & Integration Protocol |
| `DECISIONS.md` | Append-only decision log: the reasoning and rejected alternatives behind the spec |

## Protocol

- Read `CONTEXT.md` in this folder next — it routes build, rebuild, and design requests.
- The spec records **outcomes**; the decision log records **reasoning**. Design changes touch
  both: update the spec, append (never rewrite) a decision entry.
- When building, follow `SPEC.md`'s **Build & Integration Protocol** section exactly — it covers
  where to build, what existing material to preserve, and how to update the parent workspace's
  `CLAUDE.md` / `AGENTS.md` / `CONTEXT.md` so the lab is wired in, not just present.
