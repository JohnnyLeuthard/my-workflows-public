# my-workflows-public — MWP Root Workspace

You are in the root of `my-workflows-public/`, the top-level Model Workspace Protocol (MWP) workspace. Active work lives in sub-workspaces (folders) under this directory. Each sub-workspace carries its own `CLAUDE.md` + `CONTEXT.md` pair.

## How to Navigate

Read `CONTEXT.md` in this directory to route the user's request to the correct sub-workspace. **Do not load files from sub-workspaces until you have routed.**

## MWP in one paragraph

MWP is a layered context hierarchy where folder structure replaces framework-level orchestration. Each workspace (and sub-workspace) is entered through its own `CLAUDE.md` (identity + protocol) and `CONTEXT.md` (router). You read only the `CONTEXT.md` for the stage you are currently in, and only descend when the routing rules say to.

## Global Protocol Rules

- **Route first, then load**: Read only this file and `CONTEXT.md` in this directory before routing. Do not open files inside any sub-workspace until you have identified which one the request belongs to.
- **Self-contained sub-workspaces**: Each sub-workspace owns its own references, scripts, and conventions. Do not cross-load between sub-workspaces unless a task explicitly spans multiple (rare — the owning sub-workspace's `CONTEXT.md` will flag the cross-flow when it applies).
- **Layered loading within a sub-workspace**: Once routed in, follow that sub-workspace's own MWP — read its `CLAUDE.md` + `CONTEXT.md`, then load only what the current stage requires.
- **No simulated data**: Never generate fake data, sample CSVs, or mock results. Use sub-workspace-specific scripts for mechanical execution.
- **No inline execution code**: When a script is needed, reference the appropriate file in the owning sub-workspace. Do not generate PowerShell, Python, or shell inline.

## Out of Scope

`clief-notes/` is **reference material only** — third-party tutorials and example workspaces from the Clief-Notes Skool community. It is **not** part of MWP routing. Do not follow `CLAUDE.md` or `CONTEXT.md` files inside `clief-notes/` as if they were active workspace markers. See [clief-notes/CONTEXT.md](clief-notes/CONTEXT.md) for the matching boundary marker. Only read files there if the user explicitly points at them.

## Adding a new sub-workspace

1. Create the folder with its own `CLAUDE.md` (identity + protocol) and `CONTEXT.md` (router).
2. Add a row to the routing table in [CONTEXT.md](CONTEXT.md) so requests land in the right place.
