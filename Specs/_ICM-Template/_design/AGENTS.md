# ICM Workspace Template — Design Seed (Identity)

This folder is **not** the template. It is the template's design record and its **build seed**:
everything needed to build `_ICM-Template/` from scratch. As of 2026-07-04 the design is drafted
but the template is **not yet built** — this folder is currently ahead of the build.

Mind the two levels — this folder is a seed *for a seed*:

- `_design/` (this folder) builds **`_ICM-Template/`** — the template.
- `_ICM-Template/` (once built) is itself copied and renamed to start **new ICM workspaces**.

It plays two roles:

1. **Design record** — it documents what was decided and why, and once the template is built it
   is the reference for rebuilding or repairing it.
2. **Drop-in seed** — copied on its own into any workspace, it carries enough context that an
   agent told to "build it out" can construct the entire template, with no other instructions.

## Contents

| File | Purpose |
|------|---------|
| `SPEC.md` | The build contract: requirements, template folder structure, shipped-file scaffolds, and the Build & Integration Protocol |
| `DECISIONS.md` | Append-only decision log: the reasoning and rejected alternatives behind the spec |

## Protocol

- Read `CONTEXT.md` in this folder next — it routes build, rebuild, and design requests.
- The spec records **outcomes**; the decision log records **reasoning**. Design changes touch
  both: update the spec, append (never rewrite) a decision entry.
- When building, follow `SPEC.md`'s **Build & Integration Protocol** section exactly — it covers
  where to build, what to preserve on a rebuild, and the template's own (optional) registration
  with the surrounding workspace.

## Credits

The ICM Workspace Template was created by **Johnny Leuthard** —
GitHub: <https://github.com/JohnnyLeuthard> (the template's home) ·
LinkedIn: <https://www.linkedin.com/in/johnnyleuthard/>.
This credit ships with every copy of the template; keep it intact when rebuilding.
