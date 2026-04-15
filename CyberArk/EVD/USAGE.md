# EVD Pipeline — User Guide

This guide walks you through using the Export Vault Data (EVD) pipeline to extract and analyze CyberArk vault data using an AI assistant (Claude).

You don't need to know SQL, PowerShell, or the CyberArk database schema. The AI handles all of that. You just describe what you need in plain English and review the results at each step.

---

## What This Pipeline Does

The EVD pipeline turns a plain English request into a vault data report through three stages:

```
You describe what you need
        |
        v
[Stage 1: SQL Generation]  -- AI writes the SQL query
        |
    You review
        |
        v
[Stage 2: Data Fetch]      -- Script runs the query, exports CSV
        |
    You review
        |
        v
[Stage 3: Compliance Parse] -- AI analyzes data against naming standards
        |
    You review
        |
        v
Final report
```

Every stage stops and waits for your approval before moving on. Nothing runs without your say-so.

### What you get

| Stage | Output file | What it is |
|-------|-------------|------------|
| 1 — SQL Gen | `stages/01_sql_gen/output/query.sql` | Generated SQL — review before running |
| 2 — Data Fetch | `stages/02_data_fetch/output/vault_data.csv` | Live vault data — open in Excel |
| 3 — Compliance | `stages/03_parsing/output/compliance_report.md` | Flagged violations with rule IDs and severity |
| 4 — Remediation | `stages/04_remediation/output/remediation_plan.md` | Prioritized action list with recommended fixes |

---

## Before You Start

### 1. Database access

You need Windows AD group membership to query the EVD database:

| Environment | Required AD Groups |
|-------------|-------------------|
| **Prod** | `<ORG>_Prod_EPVEVD_CyberArk_USR_RO` and `<ORG>_Prod_EPVEVD_Reporting_USR_RO` |
| **UAT / Dev** | `<ORG>_UAT_EPVEVD_CyberArk_USR_RO` and `<ORG>_UAT_EPVEVD_Reporting_USR_RO` |

Standad rules and workflows need to be followed to request access to the AD group.

### 2. Configure the connection

Open `EVD.psd1` in this folder and fill in the server names for each environment:

```powershell
@{
    Environments = @{
        Dev  = @{ ServerName = 'your-dev-server.domain.com'; ... }
        UAT  = @{ ServerName = 'your-uat-server.domain.com'; ... }
        Prod = @{ ServerName = 'your-prod-server.domain.com'; ... }
    }
}
```

Replace `<DEV_SERVER_NAME>`, `<UAT_SERVER_NAME>`, and `<PROD_SERVER_NAME>` with the actual SQL Server hostnames. Leave everything else as-is unless you know it needs to change.

### 3. PowerShell requirements

- PowerShell 5.1 or later (comes with Windows)
- Network access to the SQL Server from your machine
- No extra modules needed — the script uses built-in .NET SQL classes

---

## How to Use the Pipeline

### Stage 1: Ask for what you need

Start a conversation with the AI and describe the vault data you want. Use plain English — you don't need to know table names or SQL syntax.

**Example requests:**

> "Show me all accounts in safes that start with 'Linux' with their last password change date."

> "List all accounts where CPM is disabled, grouped by safe."

> "Get me a count of accounts per platform for the Windows Server safes."

> "Show me accounts that haven't had a successful password change in over 90 days."

The AI will:
1. Read the database schema to identify the right tables and columns
2. Filter out system/infrastructure safes automatically (you can say "include system safes" if you need them)
3. Generate a SQL query and save it to `stages/01_sql_gen/output/query.sql`
4. **Stop and show you the query for review**

**What to check:**
- Does the query match what you asked for?
- Are the right columns included?
- Do the filters look correct?

If something is off, just tell the AI what to change. Once you're satisfied, tell it to proceed.

### Stage 2: Run the query

Once you approve the SQL, tell the AI to proceed. It will run the PowerShell script for you and show you the results. If you need a different environment, just say so (e.g., "run it against Dev").

**Or run it yourself** — you can also run the script manually in a terminal:

```powershell
# From the EVD/ folder
. .\scripts\Invoke-EVDQuery.ps1
Invoke-EVDQuery -SQLFile '.\stages\01_sql_gen\output\query.sql' -ExportPath '.\stages\02_data_fetch\output\vault_data.csv'
# Add -Environment Dev or -Environment UAT for non-prod
```

Either way works. The AI doesn't track internal state — it reads the output files on disk to figure out where the pipeline stands. So whether you or the AI ran the script, the result is the same CSV in the same place, and the AI picks up right where things left off.

**What to check:**
- Does the row count seem reasonable?
- Spot-check a few rows of the output

If the data looks wrong, just tell the AI what to fix. It will revise the query and re-run.

### Stage 3: Compliance analysis (optional)

If your request involves checking naming standards or compliance, tell the AI to proceed to Stage 3. It will:
1. Read the CSV data from Stage 2
2. Compare account names and metadata against the organization's naming standards
3. Generate a compliance report at `stages/03_parsing/output/compliance_report.md`

Not every query needs Stage 3. If you just needed raw data, you're done after Stage 2.

**What to check:**
- Are the findings accurate? Spot-check a few flagged accounts in PVWA to confirm.
- Do the rule IDs reference the right naming rules?

If something looks wrong, tell the AI what to investigate. When the report looks accurate, tell it to proceed.

### Stage 4: Remediation plan (optional)

If Stage 3 found compliance issues and you want a prioritized action list, tell the AI to proceed to Stage 4. It will:
1. Read the compliance report from Stage 3
2. Group findings by severity (High → Medium → Low)
3. For each finding: describe what is wrong, what the correct value should be, and what action to take
4. Identify which items can be automated via psPAS vs. which require manual PVWA action
5. Generate a remediation plan at `stages/04_remediation/output/remediation_plan.md`

The remediation plan is a decision document — it tells you what to do, not how to script it. To automate eligible items, take the plan to the `psPAS/` pipeline. To fix things manually, work through the Priority 1–3 action tables directly in PVWA.

---

## Using Templates

The pipeline includes pre-built query templates for common CyberArk tasks. Instead of describing what you need from scratch, you can ask for a template by name:

> "Run the stale accounts template"

> "Use the CPM health template for Linux safes"

> "Show me the password age template with a 60-day threshold"

The AI will load the matching template, show you the SQL with any customization options, and proceed through the normal review gate. You can still modify the query before running it.

### Available Templates

| Template | What it answers |
|----------|-----------------|
| **Stale Accounts** | Accounts not checked out by a human in N days |
| **CPM Health** | CPM disabled, failed, or errored accounts |
| **Safe Owners** | Safe metadata, account counts, and user activity per safe |
| **Account Inventory** | Account counts by safe, platform, or both |
| **Platform Compliance** | Accounts with mismatched or missing platform assignments |
| **Safe Summary** | Per-safe rollup: age, counts, last activity |
| **Orphaned Accounts** | Accounts missing critical properties (platform, address, username) |
| **Password Age** | Accounts with overdue password rotations |
| **User Lifecycle** | Vault users who are inactive, disabled, expired, or have never logged in |
| **Group Membership** | Group roster with member details; empty group detection |
| **Request Audit** | Access request history by safe; confirmation and rejection tracking |
| **PSM Session Activity** | Accounts with PSM sessions; surfaces missing or failed recordings |
| **Recently Onboarded Accounts** | Accounts created in the last N days; post-onboarding verification |

Each template is fully customizable — thresholds, safe filters, and output columns can all be adjusted based on your request.

---

## Common Tasks

### Quick data pull (Stages 1-2 only)

> "How many accounts are in each safe?"

You get a SQL query, run it, and have your CSV. No compliance parsing needed.

### Compliance audit (all 3 stages)

> "Show me all Windows accounts with their safe names and platforms — I need to check naming compliance."

The AI generates SQL, you run it, then the AI analyzes the results against naming rules and flags non-compliant accounts.

### Ad-hoc investigation

> "Show me all accounts where the last CPM error contains 'access denied'."

Great for troubleshooting CPM issues. You'll typically stop after Stage 2.

### Targeting a non-production environment

Just tell the AI which environment to use:

> "Run that against Dev instead."

The AI will target the right database automatically.

---

## Tips

- **Be specific**: "accounts in Linux safes where CPM is disabled" gives better results than "show me some accounts."
- **You can iterate**: If the SQL query isn't quite right, just tell the AI what to change. You don't need to start over.
- **System safes are excluded by default**: The AI filters out CyberArk infrastructure safes (System, VaultInternal, PSM safes, etc.) automatically. Say "include system safes" if you need them.
- **Dates in the vault are tricky**: Some date fields are stored as Unix timestamps. The AI knows how to handle this — just ask for dates normally and it will apply the right conversions.
- **Review before running**: Always look at the SQL before executing it. The AI is good but not infallible.
- **CSV output**: The CSV files use UTF-8 encoding and open cleanly in Excel. If you see garbled characters, check your Excel import settings.

---

## Folder Structure

```
EVD/
├── QUICKSTART.md            <-- Start here if you're new
├── USAGE.md                 <-- You are here
├── EVD.psd1                 <-- Connection config (fill in server names)
├── scripts/
│   └── Invoke-EVDQuery.ps1  <-- The query execution script
├── references/              <-- Schema, rules, and query templates (AI reads these)
│   └── query_templates/     <-- 13 pre-built SQL templates for common tasks
└── stages/
    ├── 01_sql_gen/
    │   └── output/          <-- Generated SQL lands here
    ├── 02_data_fetch/
    │   └── output/          <-- CSV data lands here
    ├── 03_parsing/
    │   └── output/          <-- Compliance report lands here
    └── 04_remediation/
        └── output/          <-- Remediation plan lands here
```

---

## Troubleshooting

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| "EVD.psd1 not found" | AI ran the script from the wrong directory | Tell it to run from the `EVD/` folder |
| "Environment 'X' not found" | Typo in `-Environment` parameter | Use exactly `Dev`, `UAT`, or `Prod` |
| Connection timeout | Network or firewall issue | Verify you can reach the SQL Server; check VPN |
| Access denied | Missing AD group membership | Request the appropriate AD group (see table above) |
| Zero rows returned | Query filters too narrow, or targeting wrong environment | Check your request and try `-Environment Dev` for testing |
| CSV has garbled characters | Excel encoding mismatch | Import via Data > From Text/CSV in Excel, select UTF-8 |
| Stage 3 produces no findings | Either data is clean (good) or the query didn't include the columns Stage 3 needs | If unexpected, re-check Stage 2 CSV has AccountName and SafeName columns; confirm naming_standards.md is filled in |
| Stage 4 plan has no High items | No High-severity violations in the compliance report | This is good — work through the Medium findings next, or skip Stage 4 if findings are acceptable |

---

## Walkthrough Example

**Goal**: Find all accounts in SA (Service Account) safes that are NOT on a SNOW2 platform.

### Step 1 — Ask the AI

Open a conversation and type your request in plain English:

> "Show me all accounts in safes that start with 'SA' that are not on a SNOW2 platform. Include the safe name, account name, address, username, and platform ID."

### Step 2 — AI generates the SQL (Stage 1)

The AI reads the database schema, applies the system safe exclusions, and produces a query. It saves the file to `stages/01_sql_gen/output/query.sql` and shows it to you:

```sql
SELECT
    f.CAFSafeName       AS SafeName,
    f.CAFFileName        AS AccountName,
    addr.CAOPObjectPropertyValue   AS Address,
    uname.CAOPObjectPropertyValue  AS UserName,
    pol.CAOPObjectPropertyValue    AS PlatformID
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties addr
    ON addr.CAOPFileID = CAST(f.CAFFileID AS int)
    AND addr.CAOPSafeID = f.CAFSafeID
    AND addr.CAOPObjectPropertyName = 'Address'
LEFT JOIN dbo.CAObjectProperties uname
    ON uname.CAOPFileID = CAST(f.CAFFileID AS int)
    AND uname.CAOPSafeID = f.CAFSafeID
    AND uname.CAOPObjectPropertyName = 'UserName'
LEFT JOIN dbo.CAObjectProperties pol
    ON pol.CAOPFileID = CAST(f.CAFFileID AS int)
    AND pol.CAOPSafeID = f.CAFSafeID
    AND pol.CAOPObjectPropertyName = 'PolicyID'
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
    AND f.CAFSafeName LIKE 'SA%'
    AND (pol.CAOPObjectPropertyValue IS NULL
         OR pol.CAOPObjectPropertyValue <> 'SNOW2')
    -- System safe exclusions applied automatically
    AND f.CAFSafeName NOT IN ('System', 'VaultInternal', ...)
ORDER BY f.CAFSafeName, f.CAFFileName;
```

The AI stops here and waits.

### Step 3 — Review the SQL

Look it over:
- Is it filtering on safes starting with `SA`? Yes.
- Is it excluding the `SNOW2` platform? Yes.
- Are the columns you asked for present? Yes.

If something is off, just say so:

> "Also add the last password change date."

The AI will revise the query. When it looks right, tell it to proceed.

### Step 4 — Run the query (Stage 2)

Tell the AI to proceed. It runs the query script for you and reports back:

```
query 347 rows | 00:00:02.41 | CSV: vault_data.csv
```

You don't need to open a terminal or run anything manually.

### Step 5 — Review the data

Open `stages/02_data_fetch/output/vault_data.csv`. You'll see something like:

| SafeName | AccountName | Address | UserName | PlatformID |
|----------|-------------|---------|----------|------------|
| SA-Linux-Prod | Operating System-LinuxSSH-svc_app01-... | server01.domain.com | svc_app01 | LinuxSSH |
| SA-Windows-Prod | Operating System-WinServ-svc_backup-... | server02.domain.com | svc_backup | WinServerLocal |
| SA-Oracle-Dev | Database-OracleDB-svc_dbmon-... | oradb01.domain.com | svc_dbmon | OracleDB |

These are the accounts in SA safes that are NOT on SNOW2 — exactly what you asked for.

### Step 6 — Done (or continue to compliance)

For this task, you have your report. You're done after Stage 2.

If you wanted to check whether these accounts follow naming standards, you'd tell the AI to proceed to Stage 3. It would analyze the CSV and produce a compliance report flagging any accounts that don't match the expected naming conventions.
