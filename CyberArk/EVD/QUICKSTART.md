# EVD Pipeline — Quick Start

## What this does

Takes a plain English question about your CyberArk vault and turns it into a report — no SQL, no scripting required.

This project is a reusable starting point, not a guaranteed drop-in match for every CyberArk environment. Expect to tune the configuration, naming standards, exclusions, templates, and generated SQL until they match your vault. A good workflow is to ask a question, review the SQL and CSV results, then tell the AI what looks wrong or missing so it can adjust the query or references.

---

## One-time setup

1. **Confirm database access** — you need, at minimum, read access to the target CyberArk EVD database. Follow your organization's normal process for requesting that access.

2. **Fill in server names** — open `EVD.psd1` and replace the three `<..._SERVER_NAME>` placeholders with your actual SQL Server hostnames. Leave everything else as-is.

3. **Configure vault naming standards** — update `references/naming_standards.md` with the safe naming, platform IDs, account object naming, exceptions, and severity rules used in your vault. Stage 3 compliance parsing depends on this file.

4. **Review system safe exclusions** — update `references/system_safe_exclusions.md` for your vault. Add custom infrastructure safes that should be filtered out, and remove or narrow any generic exclusions that do not apply.

5. **Review templates if you plan to use them** — templates live in `references/query_templates/`. They are optional starting points, but they should be reviewed and adjusted for your environment after `EVD.psd1`, `references/naming_standards.md`, and `references/system_safe_exclusions.md` are configured.

No modules to install.

---

## Your first run (10 minutes)

1. Open a conversation with the AI in this folder
2. Ask for the vault data you need in plain English, for example: **"Create an EVD query that shows all domain accounts not rotated in the last 30 days."**
3. Review the SQL it generates — say "looks good" to approve it
4. Run it yourself or ask the AI to run it — you'll see a row count and timing
5. Open `stages/02_data_fetch/output/vault_data.csv` in Excel

You now have live vault data. Done.

Templates are optional starting points for common requests. They live in `references/query_templates/`, with the catalog in `references/query_templates/_INDEX.md`. Review them for your environment before relying on them.

---

## Full compliance audit (30 minutes)

Follow the same first-run steps, then:

- After reviewing the CSV, say: **"Proceed to Stage 3"**
- Review the compliance report it generates
- Say: **"Proceed to Stage 4"**
- You now have a prioritized remediation plan

---

## What you get

| Stage | Output file | What it is |
|-------|-------------|------------|
| 1 — SQL Gen | `stages/01_sql_gen/output/query.sql` | Generated SQL — review before running |
| 2 — Data Fetch | `stages/02_data_fetch/output/vault_data.csv` | Live vault data — open in Excel |
| 3 — Compliance | `stages/03_parsing/output/compliance_report.md` | Flagged violations with rule IDs and severity |
| 4 — Remediation | `stages/04_remediation/output/remediation_plan.md` | Prioritized action list with recommended fixes |

These file names and locations are the canonical EVD output artifact standards. See `references/output_artifact_standards.md`.

Vault naming standards are separate: `references/naming_standards.md` applies to CyberArk vault data such as safe names, platform IDs, account object names, and compliance rule IDs.

## File flow in plain English

Think of each stage's `output/` folder as the current workbench. The file directly inside `output/` is the active file for the current run. If you want to keep an old result before replacing it, put it in that same stage's `output/archive/` folder.

| Need | Where it goes |
|------|---------------|
| Current SQL to review or run | `stages/01_sql_gen/output/query.sql` |
| Current CSV export to review or parse | `stages/02_data_fetch/output/vault_data.csv` |
| Current compliance report | `stages/03_parsing/output/compliance_report.md` |
| Current remediation plan | `stages/04_remediation/output/remediation_plan.md` |
| Previous outputs you want to keep | the matching stage's `output/archive/` folder |
| Reusable SQL pattern | `references/query_templates/` |

You can run the flow manually, ask AI to move it through each stage, or use a hybrid approach. The important rule is that the next stage reads the active file, not a random file from archive.

When you archive a SQL/CSV pair from the same request, use the same `short-purpose` name so they are easy to find together, for example `2026-05-29__domain-accounts-not-rotated-30-days.sql` and `2026-05-29__domain-accounts-not-rotated-30-days.csv`.

---

## Need more detail?

Read [USAGE.md](USAGE.md) for the full guide, including template reference, tips, troubleshooting, and a step-by-step walkthrough example.
