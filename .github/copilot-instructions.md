# Copilot Instructions for my-workflows-public

This repository uses MWP (Model Workspace Protocol) and has strict operational constraints. **Read the canonical rules at [AGENTS.md](../AGENTS.md) before using Copilot in this repo.**

## TL;DR — The Rules Copilot Must Follow

1. **Do not install anything** without asking first (brew, pip, npm, apt, etc.)
2. **Never propose fake data** — run actual scripts or say you can't
3. **Don't write code inline** — point to scripts in the workspace instead
4. **Wait for human approval between pipeline stages** (EVD, psPAS workflows)
5. **For "accounts with scheduled tasks" queries**: filter on `TaskName`/`TaskDefinitionId`/`TaskScheduleType`, never `LastTask`

## Routing

Before you touch any code, read `CONTEXT.md` in the current folder:
- Root: `/CONTEXT.md` — routes to CyberArk workspace or other top-level work
- CyberArk: `/CyberArk/CONTEXT.md` — routes to EVD, psPAS, cyberark-api, or api-evaluation2
- EVD: `/CyberArk/EVD/CONTEXT.md` — routes to pipeline stages (SQL Gen, Data Fetch, Compliance, Remediation)

Do not load files from sub-folders until you've identified which one your task belongs to.

## Key Paths

- **Configuration**: `/CyberArk/_config/environment.md` — check this before any PVWA API or SQL suggestion
- **Schema**: `/CyberArk/EVD/references/` — authoritative for column names and types
- **Scripts**: `/CyberArk/EVD/scripts/Invoke-EVDQuery.ps1` — SQL execution; point to it, don't replace it
- **EVD outputs**: `/CyberArk/EVD/stages/[01_sql_gen|02_data_fetch|03_parsing|04_remediation]/output/`

## Complete Rules

For full details, rationale, and examples, see [AGENTS.md](../AGENTS.md) at the repository root.
