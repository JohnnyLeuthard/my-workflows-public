# EVD Output Artifact Standards

> Layer 3 shared reference for pipeline file names, output locations, and artifact formats.
> This file governs files produced by the EVD pipeline. It does not define CyberArk vault data naming rules.

---

## Purpose

Use this reference whenever an agent creates, reads, archives, or hands off an EVD stage output file.

Every active pipeline artifact must be written to the stage's `output/` folder using the canonical file name below. The canonical file is the current handoff file for review and for the next stage.

When the human wants to preserve previous outputs, copy or move them into that stage's `output/archive/` folder using the archive naming rules below. Do not add timestamps, suffixes, or alternate names to the active handoff files.

## Mental Model

EVD uses one simple active lane:

1. Stage 01 writes the current SQL.
2. Stage 02 reads the current SQL and writes the current CSV.
3. Stage 03 reads the current CSV and writes the current compliance report.
4. Stage 04 reads the current compliance report and writes the current remediation plan.

The active lane is meant to be easy for humans, scripts, and AI agents to understand. Archive folders are for retained history only. They are not additional active lanes.

## Canonical Output Files

These are the active files for the current pipeline run.

| Stage | Artifact | Canonical path from `CyberArk/EVD/` | Format | Consumed by |
|-------|----------|--------------------------------------|--------|-------------|
| 01_sql_gen | Generated SQL query | `stages/01_sql_gen/output/query.sql` | SQL | Stage 02 review/input |
| 02_data_fetch | Vault data export | `stages/02_data_fetch/output/vault_data.csv` | CSV | Stage 03 review/input |
| 03_parsing | Compliance findings | `stages/03_parsing/output/compliance_report.md` | Markdown | Stage 04 review/input, optional psPAS planning |
| 04_remediation | Remediation plan | `stages/04_remediation/output/remediation_plan.md` | Markdown | Human decision, optional psPAS execution planning |

## Retained Output Files

Use retained output files when prior generated artifacts should remain available for audit, comparison, or future reuse.

| Stage | Archive location from `CyberArk/EVD/` | Archive file pattern | Example |
|-------|---------------------------------------|----------------------|---------|
| 01_sql_gen | `stages/01_sql_gen/output/archive/` | `YYYY-MM-DD__short-purpose.sql` | `2026-05-29__stale-local-admins.sql` |
| 02_data_fetch | `stages/02_data_fetch/output/archive/` | `YYYY-MM-DD__short-purpose.csv` | `2026-05-29__stale-local-admins.csv` |
| 03_parsing | `stages/03_parsing/output/archive/` | `YYYY-MM-DD__short-purpose.compliance_report.md` | `2026-05-29__stale-local-admins.compliance_report.md` |
| 04_remediation | `stages/04_remediation/output/archive/` | `YYYY-MM-DD__short-purpose.remediation_plan.md` | `2026-05-29__stale-local-admins.remediation_plan.md` |

When archiving files from the same request, use the same `short-purpose` stem across stages so related artifacts are easy to retrieve together.

## Reusable SQL

Retained SQL and reusable SQL are related, but not the same thing.

| Need | Location | Naming |
|------|----------|--------|
| Keep the exact generated SQL from a previous request | `stages/01_sql_gen/output/archive/` | `YYYY-MM-DD__short-purpose.sql` |
| Create a reusable query pattern agents should discover before regenerating SQL | `references/query_templates/` | Numbered Markdown template, such as `14_short_purpose.md`, and update `references/query_templates/_INDEX.md` |

Use `output/archive/` for history. Use `references/query_templates/` for curated, reusable patterns.

## Retrieval and Cleanup

| Task | Process |
|------|---------|
| Retrieve an archived output for review | Open the file directly from the matching `output/archive/` folder. |
| Continue the pipeline from an archived output | Copy the selected archived file back to the matching canonical active path first. |
| Clean up old retained outputs | Delete files from `output/archive/` that are no longer needed. Keep the canonical active files and `.gitkeep` files. |
| Preserve a useful query for future agents | Convert it into a query template under `references/query_templates/` instead of leaving it only in archive. |

## File Naming Rules

| Rule | Requirement |
|------|-------------|
| Canonical names | Use the exact file names in the table above for normal pipeline runs. |
| Canonical locations | Write each file only to its owning stage's `output/` folder. |
| Path style in docs | Reference paths from the `CyberArk/EVD/` root unless a repository-root path is needed for clarity. |
| Review gates | Stop after writing a stage output and wait for human approval before using it as the next stage input. |
| Examples | Example artifacts may use `.EXAMPLE` before the extension, such as `compliance_report.EXAMPLE.md`. |
| Archives | Use `output/archive/` and the archive pattern above when the human asks to keep prior outputs. |
| Archive slugs | Use lowercase kebab-case for `short-purpose`: letters, numbers, and hyphens only. |
| Active vs archived | Never use archived files as the next stage input unless the human explicitly selects one. Copy the selected archive back to the canonical active path first. |

## Boundary With Vault Naming Standards

This file is for naming and locating EVD output artifacts.

`references/naming_standards.md` is for CyberArk vault data naming rules, including safe names, platform IDs, account object names, and compliance rule IDs. Do not use `references/naming_standards.md` as a file naming standard.
