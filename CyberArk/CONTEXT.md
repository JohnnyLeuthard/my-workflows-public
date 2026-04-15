# CyberArk Workspace Router

Read the user's request and route to the correct sub-workspace.

## Routing Rules

| If the request involves...                        | Route to...            |
|---------------------------------------------------|------------------------|
| Querying vault data, SQL generation, CSV analysis | `EVD/CONTEXT.md`       |
| Vault changes, remediation, psPAS commands        | `psPAS/CONTEXT.md`     |

## Cross-Workspace Flow

Some requests span both pipelines. For example, "find non-compliant accounts and fix them" requires:
1. First route to `EVD/CONTEXT.md` to extract and analyze the data.
2. Then route to `psPAS/CONTEXT.md` to plan and execute remediation using EVD's output.

## Global Constraints

- **Naming standards**: All outputs must follow the naming rules bundled inside each pipeline's `references/` folder. Internalize these as constraints.
- **Mechanical execution**: Use pipeline-specific scripts for running SQL queries and calling APIs. Never generate inline execution code.
