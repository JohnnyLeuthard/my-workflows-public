# Hello-World — Design Seed (Identity)

This folder is **not** the hello-world tutorial. It is the tutorial's design record and its
**build seed**: everything needed to (re)build the smallest ICM demo from scratch — a working
class demonstration — and plug it into whatever workspace it lands in, at any depth.

It plays two roles:

1. **Design record** — when it sits inside a built `hello-world/`, it documents what was decided
   and why, and is the reference for rebuilding or repairing the demo.
2. **Drop-in seed** — copied on its own anywhere, it carries enough context that an agent told to
   "build it out" can construct the entire demo, wire it into **every** `CLAUDE.md` / `AGENTS.md`
   / `CONTEXT.md` up the chain above it, verify it end to end, and reset it fresh for a class —
   with no other instructions.

## Contents

| File | Purpose |
|------|---------|
| `SPEC.md` | The build contract: requirements, verbatim scaffolds of every file, the Build & Integration Protocol, and class demo notes |
| `DECISIONS.md` | Append-only decision log: the reasoning and rejected alternatives behind the spec |

## Protocol

- Read `CONTEXT.md` in this folder next — it routes build, rebuild, and design requests.
- The spec records **outcomes**; the decision log records **reasoning**. Design changes touch
  both: update the spec, append (never rewrite) a decision entry.
- When building, follow `SPEC.md`'s **Build & Integration Protocol** section exactly — it covers
  where to build, the chain-walk that updates every level above the lab, and the
  verify-then-reset step that leaves the demo fresh for an audience.
