# command-reviewer — Design Seed (Router)

Route requests about this folder using the table below.

## Routing Rules

| If the request involves... | Route to... |
|---|---|
| Building the workspace out, rebuilding it, repairing missing files | [SPEC.md](SPEC.md) — follow its **Build & Integration Protocol** section |
| Why the workspace is designed a certain way, evaluating a design change | [DECISIONS.md](DECISIONS.md), with [SPEC.md](SPEC.md) for the current outcome |
| Changing the design | Update [SPEC.md](SPEC.md) **and** append an entry to [DECISIONS.md](DECISIONS.md) — never rewrite old entries |
| Actually reviewing a command | A built workspace's own chain (its `CLAUDE.md`) — this seed does no review work. If no workspace is built yet, offer to build one from [SPEC.md](SPEC.md) first |
| What the scores mean, how reports are structured | A built workspace's `reference/` files — the live rules, not a design question |
| Planned future enhancements, or what happened to a previously planned item | [NEXT-STEPS.md](NEXT-STEPS.md) — intent only; designing an item means updating SPEC.md + DECISIONS.md |

## Build Quick-Reference

The full protocol lives in `SPEC.md` (Build & Integration Protocol). In short:

1. **Locate**: build into a `command-reviewer/` folder wherever the human wants the workspace
   to live. This seed stays where it is — it is never moved into, shipped with, or referenced
   by the built workspace.
2. **Build**: front-door chain → stage files → `reference/` → `output/` + READMEs, per the
   spec's Workspace Structure and per-file requirements — always from scratch. On a rebuild,
   `output/` (the user's archive) is preserved untouched; confirm before overwriting any
   customized file.
3. **Plug in (optional)**: if the parent has a `CONTEXT.md` router and the human wants it, add
   a row routing "review this command" requests to `command-reviewer/CLAUDE.md`, following the
   parent's own row conventions. No parent chain → the workspace stands alone. Report exactly
   what was changed.
4. **Verify**: run the audit in the spec's Verify section — every route resolves, both stages
   state reads/does/writes + prerequisite, then a live `node -v` test review end to end.
