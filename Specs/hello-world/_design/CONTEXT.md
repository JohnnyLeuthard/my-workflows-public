# Hello-World — Design Seed (Router)

Route requests about this folder using the table below.

## Routing Rules

| If the request involves...                                        | Route to...                          |
|--------------------------------------------------------------------|--------------------------------------|
| Building the demo out, rebuilding it, repairing missing files       | [SPEC.md](SPEC.md) — follow its **Build & Integration Protocol** section |
| Why the demo is designed a certain way, evaluating a design change  | [DECISIONS.md](DECISIONS.md), with [SPEC.md](SPEC.md) for the current outcome |
| Changing the design                                                 | Update [SPEC.md](SPEC.md) **and** append an entry to [DECISIONS.md](DECISIONS.md) — never rewrite old entries |
| Running the tutorial itself, prepping or resetting a class demo     | The built demo's own chain: `../CLAUDE.md`. If it is not built yet, offer to build it from [SPEC.md](SPEC.md) first. To reset: empty `../output/power.md` |

## Build Quick-Reference

The full protocol lives in `SPEC.md` (Build & Integration Protocol). In short:

1. **Locate**: if this folder's parent is the demo folder (even empty), build into the parent.
   Dropped anywhere else, create `hello-world/` beside it, move `_design/` inside, and build there.
2. **Build**: create every missing file from the verbatim scaffolds in `SPEC.md`
   (`output/power.md` ships empty). Confirm before overwriting a customized file.
3. **Plug in**: walk **every level upward** to the workspace root — add a router row where a
   `CONTEXT.md` exists, a pointer where only `CLAUDE.md`/`AGENTS.md` exist, skip bare folders
   (upper routers may link down through them). Add-only; report every file changed at every level.
4. **Verify, then reset**: run the tutorial end to end, confirm `output/power.md` reads
   `CONTROL YOUR AGENT` and the run ends with DONE, BOSS!!! — then empty `output/power.md` so the
   class demo starts fresh.
