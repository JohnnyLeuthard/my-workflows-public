# ICM Workspace Template — Design Seed (Router)

Route requests about this folder using the table below.

## Routing Rules

| If the request involves...                                        | Route to...                          |
|--------------------------------------------------------------------|--------------------------------------|
| Building the template out, rebuilding it, repairing missing files   | [SPEC.md](SPEC.md) — follow its **Build & Integration Protocol** section |
| Why the template is designed a certain way, evaluating a change     | [DECISIONS.md](DECISIONS.md), with [SPEC.md](SPEC.md) for the current outcome |
| Changing the design                                                 | Update [SPEC.md](SPEC.md) **and** append an entry to [DECISIONS.md](DECISIONS.md) — never rewrite old entries |
| Actually starting a new workspace from the template                 | The built template's own chain: `../CLAUDE.md` (and `../README.md` for the human steps). If the template is not built yet, offer to build it from [SPEC.md](SPEC.md) first |

## Build Quick-Reference

The full protocol lives in `SPEC.md` (Build & Integration Protocol). In short:

1. **Locate**: if this folder's parent is the template folder (even empty), build into the
   parent. If this folder was dropped straight into a workspace root, create `_ICM-Template/`
   beside it, move `_design/` inside, and build there.
2. **Build**: create everything in the spec's Template Folder Structure — `README.md`,
   `NEXT-STEPS.md`, the seed-mode front-door chain, `docs/` explainers, `_setup/` (setup stage
   instructions + interview guide), and `reference/` (ICM checklist + scripts rule).
3. **Register (optional)**: the template is standalone by default. If the surrounding workspace
   has a `CONTEXT.md` router and the human wants it, add a row routing "start a new ICM
   workspace" requests to the template. Report exactly what was changed.
4. **Verify**: structural checks per the spec's Verify section, then walk the human through a
   dry read of `README.md` — do not run a real workspace setup as a test unless asked.
