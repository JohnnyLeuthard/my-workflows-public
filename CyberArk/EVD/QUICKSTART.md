# EVD Pipeline — Quick Start

## What this does

Takes a plain English question about your CyberArk vault and turns it into a report — no SQL, no scripting required.

---

## One-time setup (5 minutes)

1. **Request AD group access** — you need read-only access to the EVD database:
   - Prod: `<ORG>_Prod_EPVEVD_CyberArk_USR_RO` and `<ORG>_Prod_EPVEVD_Reporting_USR_RO`
   - UAT/Dev: `<ORG>_UAT_EPVEVD_CyberArk_USR_RO` and `<ORG>_UAT_EPVEVD_Reporting_USR_RO`

2. **Fill in server names** — open `EVD.psd1` and replace the three `<..._SERVER_NAME>` placeholders with your actual SQL Server hostnames. Leave everything else as-is.

That's it. No modules to install.

---

## Your first run (10 minutes)

1. Open a conversation with the AI in this folder
2. Say: **"Run the stale accounts template"**
3. Review the SQL it generates — say "looks good" to approve it
4. It runs the query automatically — you'll see a row count and timing
5. Open `stages/02_data_fetch/output/vault_data.csv` in Excel

You now have live vault data. Done.

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

---

## Need more detail?

Read [USAGE.md](USAGE.md) for the full guide, including template reference, tips, troubleshooting, and a step-by-step walkthrough example.
