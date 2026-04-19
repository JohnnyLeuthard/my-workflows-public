# my-workflows-public — Root Router

Read the user's request and route to the correct sub-workspace.

## Routing Rules

| If the request involves...                                              | Route to...                |
|-------------------------------------------------------------------------|----------------------------|
| CyberArk vault operations — EVD queries, psPAS remediation, REST API    | [CyberArk/CONTEXT.md](CyberArk/CONTEXT.md)   |

*More sub-workspaces will be added over time. See "Adding a sub-workspace" below.*

## Out of Scope (Do Not Route Here)

| Folder | Why |
|--------|-----|
| [clief-notes/](clief-notes/) | Third-party reference material from the Clief-Notes Skool community. **Not** an active workspace. See [clief-notes/CONTEXT.md](clief-notes/CONTEXT.md). Only read on explicit user request. |

## Global Constraints

- **Route first, then load**: Read only this file and [CLAUDE.md](CLAUDE.md) at this level before routing. Do not open files inside a sub-workspace until you have identified which one the request belongs to.
- **Lazy-load inside sub-workspaces**: After routing, each sub-workspace has its own `CONTEXT.md` (and often a `references/_INDEX.md`) — follow its rules, don't preload.
- **No cross-sub-workspace preloading**: A request routed to one sub-workspace must not also pull files from another unless that sub-workspace's `CONTEXT.md` explicitly describes a cross-flow.
- **Ignore `clief-notes/`**: Never follow routing from files inside `clief-notes/` — even if they contain `CLAUDE.md`/`CONTEXT.md` files that look like workspace markers, they belong to example workspaces and are not part of this repo's MWP.

## Adding a sub-workspace

1. Create a new top-level folder.
2. Give it its own `CLAUDE.md` (workspace identity + protocol) and `CONTEXT.md` (router into its stages).
3. Add a row to the **Routing Rules** table above so requests land in the right place.
