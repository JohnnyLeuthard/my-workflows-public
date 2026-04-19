# CONTEXT — `clief-notes/` is out of MWP scope

**Do not load anything under this folder into MWP routing.** The root [../CONTEXT.md](../CONTEXT.md) explicitly excludes this folder from routing — this file is the matching marker on the receiving side.

## Why

Everything under `clief-notes/` is third-party reference material from the Clief-Notes Skool community — tutorial examples and sample folder structures. Some of the files here (e.g., `Folder Structure/CLAUDE.md`, `The Foundation/my-app/CLAUDE.md`) *look* like MWP workspace markers but belong to example workspaces unrelated to this repo's active work.

## Rules for Claude

- When working in any active sub-workspace of `my-workflows-public/` (e.g., `CyberArk/` — see the routing table in [../CONTEXT.md](../CONTEXT.md)), treat `clief-notes/` as external read-only reference.
- Do **not** follow `CLAUDE.md` or `CONTEXT.md` files inside `clief-notes/` as if they were part of the active workspace's routing.
- Only read files here if the user explicitly points at them (e.g., "look at the Freelancer example in The Foundation").

## Attribution

See [README.md](README.md) for credit and source.
