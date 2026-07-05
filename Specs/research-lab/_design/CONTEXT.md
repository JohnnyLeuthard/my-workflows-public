# Research Lab — Design Seed (Router)

Route requests about this folder using the table below.

## Routing Rules

| If the request involves...                                        | Route to...                          |
|--------------------------------------------------------------------|--------------------------------------|
| Building the lab out, rebuilding it, repairing missing files        | [SPEC.md](SPEC.md) — follow its **Build & Integration Protocol** section |
| Why the lab is designed a certain way, evaluating a design change   | [DECISIONS.md](DECISIONS.md), with [SPEC.md](SPEC.md) for the current outcome |
| Changing the design                                                 | Update [SPEC.md](SPEC.md) **and** append an entry to [DECISIONS.md](DECISIONS.md) — never rewrite old entries |
| Running research, fact-checking, adding a specialist — actual lab work | The built lab's own chain: `../CLAUDE.md`. If the lab is not built yet, offer to build it from [SPEC.md](SPEC.md) first |

## Build Quick-Reference

The full protocol lives in `SPEC.md` (Build & Integration Protocol). In short:

1. **Locate**: if this folder's parent is the lab folder (even empty), build into the parent. If
   this folder was dropped straight into a workspace root, create `research-lab/` beside it,
   move `_design/` inside, and build there.
2. **Build**: create the full structure per the spec — front-door chain, the `HOW-TO-USE.md`
   user guide, dispatcher, synthesis, the six reference files, `specialists/_template/`, the
   four starter specialists, `input/_template/`, and the two shipped sample requests. Preserve
   existing human material (added specialists, real input jobs, everything under `output/`);
   confirm before overwriting a customized machine file.
3. **Plug in**: update the parent workspace — replace any router row pointing at this seed with
   one pointing at the built lab's `CLAUDE.md`, per that workspace's own conventions. If there
   is no parent chain, the lab stands alone. Report exactly what changed.
4. **Verify**: structural checks per the spec's Verify list, then offer the human a first run on
   a shipped sample — do not auto-run one, since every run ends at a human checkpoint.
