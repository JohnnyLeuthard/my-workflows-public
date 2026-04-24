# CyberArk Workspace Router

Read the user's request and route to the correct sub-workspace.

## Routing Rules

| If the request involves...                                          | Route to...                    |
|---------------------------------------------------------------------|--------------------------------|
| Querying vault data, SQL generation, CSV analysis                   | `EVD/CONTEXT.md`               |
| Vault changes, remediation, psPAS commands                          | `psPAS/CONTEXT.md`             |
| Direct REST API calls, building API functions/scripts, no psPAS     | `cyberark-api/CONTEXT.md`      |
| API version tracking, per-version endpoint reference, version diffs **(reference library — no live calls)** | `api-evaluation/CONTEXT.md`    |

## Cross-Workspace Flow

Some requests span multiple pipelines. Common flows:

**Find and fix (EVD → psPAS or cyberark-api):**
1. Route to `EVD/CONTEXT.md` to extract and analyze data (produces `compliance_report.md` or `remediation_plan.md`).
2. Route to `psPAS/CONTEXT.md` (if psPAS is available) **or** `cyberark-api/CONTEXT.md` (if direct API preferred) to execute remediation.

**psPAS vs. cyberark-api:** Both execute vault changes. Use `psPAS` when the psPAS module is installed and cmdlet coverage is sufficient. Use `cyberark-api` when psPAS is unavailable, when you need an operation psPAS doesn't cover, or when you prefer direct REST control.

## Global Constraints

- **Route first, then load**: Read only this file and `CLAUDE.md` at the CyberArk sub-workspace root before routing. Do not open files inside EVD/, psPAS/, or cyberark-api/ until you have identified which sub-workspace the request belongs to.
- **Lazy-load references**: After routing, load only the reference files required for the current task. Each sub-workspace has a `references/_INDEX.md` — read that first to identify which specific file to load. Never preload all reference files.
- **Naming standards**: All outputs must follow the naming rules in the owning sub-workspace's `references/` folder. Internalize these as constraints before generating any output.
- **Mechanical execution**: Use workspace-specific scripts and module functions for execution. Never generate inline execution code in response messages.
- **No cross-workspace preloading**: If a request routes to `cyberark-api`, do not also load EVD schema files or psPAS cmdlet references unless the task explicitly spans both workspaces.
