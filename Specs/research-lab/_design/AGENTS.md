# Research Lab — Design Seed (Identity)

This folder is **not** the research lab. It is the lab's design record and its **build seed**:
everything needed to build the research/fact-checking lab from scratch and plug it into whatever
workspace it lands in. The design was locked 2026-07-05; the lab has **not been built yet** — it
waits on the human's go.

It plays two roles:

1. **Design record** — it documents what was decided and why, and once the lab is built it is the
   reference for rebuilding or repairing it.
2. **Drop-in seed** — copied on its own into any workspace, it carries enough context that an
   agent told to "build it out" can construct the entire lab and register it with the parent
   workspace, with no other instructions.

## Contents

| File | Purpose |
|------|---------|
| `SPEC.md` | The build contract: requirements, folder structure, specialist template scaffolds, and the Build & Integration Protocol |
| `DECISIONS.md` | Append-only decision log: the reasoning and rejected alternatives behind the spec |

## Protocol

- Read `CONTEXT.md` in this folder next — it routes build, rebuild, and design requests.
- The spec records **outcomes**; the decision log records **reasoning**. Design changes touch
  both: update the spec, append (never rewrite) a decision entry.
- When building, follow `SPEC.md`'s **Build & Integration Protocol** section exactly — it covers
  where to build, what existing material to preserve, and how to update the parent workspace's
  `CLAUDE.md` / `AGENTS.md` / `CONTEXT.md` so the lab is wired in, not just present.
