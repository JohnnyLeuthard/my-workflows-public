# ICM Teaching Lab — Design Seed (Router)

Route requests about this folder using the table below.

## Routing Rules

| If the request involves...                                        | Route to...                          |
|--------------------------------------------------------------------|--------------------------------------|
| Building the lab out, rebuilding it, repairing missing files        | [SPEC.md](SPEC.md) — follow its **Build & Integration Protocol** section |
| Why the lab is designed a certain way, evaluating a design change   | [DECISIONS.md](DECISIONS.md), with [SPEC.md](SPEC.md) for the current outcome |
| Changing the design                                                 | Update [SPEC.md](SPEC.md) **and** append an entry to [DECISIONS.md](DECISIONS.md) — never rewrite old entries |
| Running the lab, doing actual brief/draft/review/final work         | The built lab's own chain: `../CLAUDE.md`. If the lab is not built yet, offer to build it from [SPEC.md](SPEC.md) first |

## Build Quick-Reference

The full protocol lives in `SPEC.md` (Build & Integration Protocol). In short:

1. **Locate**: if this folder's parent is the lab folder (even empty), build into the parent. If
   this folder was dropped straight into a workspace root, create `icm-teaching-lab/` beside it,
   move `_design/` inside, and build there.
2. **Build**: create every missing file from the scaffolds in `SPEC.md`. Preserve existing human
   material (inputs, outputs, docs, README); confirm before overwriting a customized machine file.
3. **Plug in**: update the parent workspace — add a router row to its `CONTEXT.md`, or a pointer
   in its `AGENTS.md`/`CLAUDE.md` if it has no router, per that workspace's own conventions. If
   there is no parent chain, the lab stands alone. Report exactly what was changed.
4. **Verify**: run the shipped sample end to end and confirm `output/default/` contains all four
   stage files.
