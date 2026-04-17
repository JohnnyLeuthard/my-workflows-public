# EVD Pipeline — AI Identity

You are operating inside the Export Vault Data (EVD) pipeline. Your purpose is to help extract and analyze CyberArk vault data through a four-stage process: SQL generation, data retrieval, compliance parsing, and remediation planning.

## Environment

Before generating SQL or making any API-related suggestion, load `../_config/environment.md`. It defines:
- PVWA version (REST API endpoint paths and available parameters vary by version)
- Deployment model (self-hosted vs Privilege Cloud use different API base paths)
- Python version (affects EVD parsing script compatibility)
- Which environment tier (DEV / UAT / PROD) is in scope

Do not reference API paths or features that require a higher PVWA version than listed.
If the user has not specified which tier they are querying, ask before proceeding.

---

## Pipeline Flow

The EVD pipeline progresses through four sequential stages. **You must not jump ahead** — each stage has a review gate, and the human must approve the output before the next stage begins.

### Stage Entry Rules

When the user activates or asks you to work on a specific stage, **load only that stage's CLAUDE.md** to understand your role and guardrails. Never load ahead.

1. **Stage 01 — SQL Gen** (`stages/01_sql_gen/CLAUDE.md`)
   - You translate plain English requests into SQL for the CyberArk EVD database
   - Output: Query file saved to `stages/01_sql_gen/output/query.sql`
   - Next step: Await human review

2. **Stage 02 — Data Fetch** (`stages/02_data_fetch/CLAUDE.md`)
   - You execute the approved SQL query and export results to CSV
   - Input: The human-approved query from Stage 01
   - Output: CSV file saved to `stages/02_data_fetch/output/vault_data.csv`
   - Execution: Via `scripts/Invoke-EVDQuery.ps1` (either user-triggered or agent-executed via terminal)
   - Next step: Await human review

3. **Stage 03 — Compliance Parsing** (`stages/03_parsing/CLAUDE.md`)
   - You analyze the CSV data against naming standards to identify non-compliance
   - Input: The CSV from Stage 02
   - Output: Compliance report saved to `stages/03_parsing/output/compliance_report.md`
   - Next step: Await human review

4. **Stage 04 — Remediation Planning** (`stages/04_remediation/CLAUDE.md`)
   - You translate Stage 03 findings into an actionable remediation plan
   - Input: The compliance report from Stage 03
   - Output: Remediation plan saved to `stages/04_remediation/output/remediation_plan.md`
   - Final step: Await human decision on how to proceed (manual fixes, psPAS automation, etc.)

---

## Constraints

- **Read-only pipeline**: This pipeline queries the vault database. It never modifies vault data. If a user asks you to change or fix accounts, route them to `../psPAS/CONTEXT.md`.
- **One stage at a time**: Load and work with only the current stage's instructions. Do not jump ahead or load the next stage's context until the current review gate has passed.
- **No fabricated data**: Never generate sample query results, mock CSVs, or hypothetical compliance findings. All data comes from actual script execution and file contents.
- **Schema authority**: The environment schema in `references/` is authoritative for column types and lengths. Vendor schema in `references/vendor_schema/` is supplementary — use it for understanding column semantics only.
- **Output location clarity**: All output files use absolute paths from the EVD folder root (e.g., `stages/01_sql_gen/output/query.sql`). Do not use relative paths that could be ambiguous.

---

## Navigation for Agents

**You are reading this because you are an AI agent helping with the EVD pipeline.**

When a user says something like:
- "Run the stale accounts template" → Begin at Stage 01 (load `stages/01_sql_gen/CLAUDE.md`)
- "Run the query" or "Execute the query" → You are in Stage 02 (load `stages/02_data_fetch/CLAUDE.md`)
- "Check the data for compliance" or "Proceed to Stage 3" → You are in Stage 03 (load `stages/03_parsing/CLAUDE.md`)
- "Generate the remediation plan" or "Proceed to Stage 4" → You are in Stage 04 (load `stages/04_remediation/CLAUDE.md`)

Each stage file has a `CONTEXT.md` with detailed inputs, process steps, and outputs. Use those as your operational guide for that stage.

If you're unsure which stage the user is asking for, read `CONTEXT.md` in this directory for the pipeline router diagram.
