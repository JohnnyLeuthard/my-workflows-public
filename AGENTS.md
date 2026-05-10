# AGENTS.md — Rules for All AI Tools

This file contains operational rules and constraints for **any AI tool or agent** working in this repository (Claude, Copilot, Cursor, Windsurf, custom agents, etc.). If you're using an AI to help with work in this repo, read this first.

---

## Core Protocol: MWP (Model Workspace Protocol)

This repository is organized as a **layered context hierarchy** using folder structure. Before loading *any* file from a sub-folder, you must read the routing instructions at each level.

### How to Navigate

1. **Start here**: Read `CONTEXT.md` in the current directory.
2. **Don't preload**: Do not open files inside sub-folders until the routing file tells you which one your request belongs to.
3. **Follow the chain**: After routing, each sub-folder has its own `CLAUDE.md` (identity) and `CONTEXT.md` (next-level router). Follow them recursively until you reach the operational stage.
4. **Lazy-load only**: Load only the files required for your current task. Never bulk-load all documentation.

### Directory Structure Overview

- **Root** (`/CONTEXT.md`): Routes between top-level workspaces
- **CyberArk/** (`/CyberArk/CONTEXT.md`): Routes between CyberArk sub-pipelines (EVD, psPAS, cyberark-api, api-evaluation2)
  - **EVD/** (`/CyberArk/EVD/CONTEXT.md`): Routes between four sequential pipeline stages (SQL Gen → Data Fetch → Compliance Parsing → Remediation Planning)
  - **psPAS/**: PowerShell-based vault remediation
  - **cyberark-api/**: Direct REST API integration (module, not staged)
  - **api-evaluation2/**: API reference library by version (no live calls)

- **clief-notes/**: **Reference material only** — do not treat as an active workspace, even if it contains `CLAUDE.md`/`CONTEXT.md` files.

---

## Universal Constraints

These rules apply to **all work in this repository**, regardless of which tool you're using or which sub-workspace you're in.

### 1. Never Install Packages Without Permission

**Rule**: Do not run `brew install`, `pip install`, `pip3 install`, `npm install -g`, `apt-get install`, `apt install`, `yum install`, `pacman -S`, `gem install`, `cargo install`, `go install`, `conda install`, or `composer require` without explicit human approval.

**Why**: Installing software without permission is a security violation and violates informed consent. It can install malware, compromise the system, or modify the development environment unexpectedly.

**How to apply**:
- If you need a tool or library to complete a task, **stop and ask first**: "I need to install X to proceed. Do you want me to continue?"
- Check the user's `.claude/settings.local.json` (personal) and `.claude/settings.json` (repo-level) for permission requirements before attempting any installation
- Never assume you can work around missing dependencies by installing them silently
- If the tool isn't available, suggest alternatives or ask the user to install it manually

### 2. No Simulated or Fabricated Data

**Rule**: Never generate sample results, mock CSVs, fake query outputs, or hypothetical compliance reports. All data must come from actual execution or file contents.

**Why**: Fake data masks real issues and misleads decision-making. If you can't run the actual process, say so.

**How to apply**:
- If a query hasn't been run, don't invent the results
- If you can't access a file, don't fabricate its contents
- If a command would produce output, actually run it (or report that you can't)

### 3. No Inline Execution Code

**Rule**: Do not write PowerShell, Python, Bash, or other code inline in responses with the expectation the user will copy/paste and run it.

**Why**: Inline code is error-prone, hard to maintain, and doesn't benefit from version control or code review.

**How to apply**:
- Point to existing scripts in the workspace instead: "Run `scripts/Invoke-EVDQuery.ps1`"
- If a new script is needed, create a file in the appropriate `scripts/` folder and commit it
- Reference the script path in your response, never the code

### 4. Review Gates — Stage-by-Stage Approval

**Rule**: Every CyberArk pipeline stage requires explicit human approval before proceeding to the next stage.

**Why**: Vault operations are high-risk. Humans must verify each output before the next step executes.

**How to apply**:
- After you produce output (SQL query, CSV, compliance report, remediation plan), **stop and wait**
- Do not automatically load the next stage or proceed without human sign-off
- When the human approves, they will explicitly say so; then you may proceed

### 5. Schema and References Are Authoritative

**Rule**: When writing SQL or interpreting data, use the schema definitions in each sub-workspace's `references/` folder. Those files are the source of truth for column names, types, and meanings.

**Why**: Assumptions about schema lead to wrong queries and data misinterpretation.

**How to apply**:
- Before writing a SQL query, load `CyberArk/EVD/references/_INDEX.md` to find the right schema file
- Use schema files to verify column names, data types, and lengths
- If a column name seems ambiguous, check `references/vendor_schema/` for CyberArk's official definition, then use the environment schema as your guide

---

## CyberArk-Specific Constraints

### EVD Domain Rule: LastTask vs. TaskName (Scheduled Task Queries)

**Rule**: When a request asks for "accounts with scheduled tasks," filter on `TaskName`, `TaskDefinitionId`, or `TaskScheduleType` from the CyberArk task scheduling property family. **Never use `LastTask`** as an indicator of scheduled tasks.

**Why**: `LastTask` is a CPM (Central Password Manager) history field that records when the last password change occurred — it has nothing to do with scheduled tasks. Using it to find accounts with scheduled tasks returns wrong rows.

**How to apply**:
- If a query request mentions "scheduled tasks," "task schedule," "recurring task," or similar: use `TaskName`, `TaskDefinitionId`, or `TaskScheduleType` from the task scheduling properties
- `LastTask` is valid for other use cases (e.g., "when was the password last changed?"), but never for identifying accounts *with* scheduled tasks
- When writing compliance rules or remediation checks that depend on scheduled tasks, document which task property you're filtering on
- See `CyberArk/EVD/references/` (file `eva_query_patterns.md`) for example queries using task scheduling properties correctly

---

## File Organization

### Output and Naming

Each pipeline stage has an `output/` folder where results live. Use these locations:

- `CyberArk/EVD/stages/01_sql_gen/output/query.sql` — Generated SQL query
- `CyberArk/EVD/stages/02_data_fetch/output/vault_data.csv` — Query results as CSV
- `CyberArk/EVD/stages/03_parsing/output/compliance_report.md` — Compliance findings
- `CyberArk/EVD/stages/04_remediation/output/remediation_plan.md` — Remediation steps

### Scripts and Execution

- Don't generate inline code; point to workspace scripts
- Common scripts:
  - `CyberArk/EVD/scripts/Invoke-EVDQuery.ps1` — Execute SQL queries against the vault
  - Reference the appropriate script in your response

---

## For Tool Integrations

If you're setting up **Copilot**, **Cursor**, **Windsurf**, or another tool to work with this repo, also check:
- `.github/copilot-instructions.md` (GitHub Copilot)
- `.cursorrules` (Cursor IDE)

Each of those files references this `AGENTS.md` as the canonical source and provides tool-specific guidance on top.

---

## Questions or Ambiguity?

If you encounter a situation not covered here:
1. Check the current folder's `CONTEXT.md` for routing
2. Check the relevant stage's `CLAUDE.md` for constraints
3. If still unclear, ask the human — don't guess

---

**Last Updated**: 2026-05-10  
**Scope**: All AI agents, all tools, all sub-workspaces  
**Canonical**: This file; tool-specific integrations are pointers only
