# Content Lab — Design Seed (Router)

Route requests about this folder using the table below.

## Routing Rules

| If the request involves...                                        | Route to...                          |
|--------------------------------------------------------------------|--------------------------------------|
| Building the lab out, rebuilding it, repairing missing files        | [SPEC.md](SPEC.md) — follow its **Build & Integration Protocol** section |
| Why the lab is designed a certain way, evaluating a design change   | [DECISIONS.md](DECISIONS.md), with [SPEC.md](SPEC.md) for the current outcome |
| Changing the design                                                 | Update [SPEC.md](SPEC.md) **and** append an entry to [DECISIONS.md](DECISIONS.md) — never rewrite old entries |
| Writing a blog post, running a channel, doing actual content work   | The built lab's own chain: `../CLAUDE.md`. If the lab is not built yet, offer to build it from [SPEC.md](SPEC.md) first |

## Build Quick-Reference

The full protocol lives in `SPEC.md` (Build & Integration Protocol). In short:

1. **Locate**: if this folder's parent is the lab folder (even empty, or holding the legacy
   structure), build into the parent. If this folder was dropped straight into a workspace root,
   create the lab folder beside it, move `_design/` inside, and build there.
2. **Build**: create the full structure per the spec — front-door chain, the `HOW-TO-USE.md`
   user guide, the blog pipeline stages, `input/_template/`, the two v1 channels (`linkedin`,
   `remotion`), the reference and `_config/` files, the tracker, and the shipped sample input.
3. **Preserve**: never silent-delete human material. If the legacy `Writing/` / `LinkedIn/`
   structure is present, offer to move it to `_archive/`; carry forward existing `reference/`
   content where the spec names a matching file.
4. **Plug in**: update the parent workspace — add or update a router row in its `CONTEXT.md`, or
   a pointer in its `AGENTS.md`/`CLAUDE.md` if it has no router, per that workspace's own
   conventions. If there is no parent chain, the lab stands alone. Report exactly what changed.
5. **Verify**: structural checks per the spec's Verify list, then offer the human a first run on
   the shipped sample — do not auto-run it, since the pipeline ends at a human checkpoint.
