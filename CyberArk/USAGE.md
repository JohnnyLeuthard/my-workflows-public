# CyberArk Workspace — Getting Started

This workspace uses an AI assistant (Claude) to help you work with CyberArk vault data. You describe what you need in plain English, and the AI handles the technical details — SQL queries, data extraction, compliance analysis, and eventually remediation.

No SQL or PowerShell knowledge required. Each step stops for your review before anything runs.

---

## Available Pipelines

| Pipeline | Purpose | Status | Guide |
|----------|---------|--------|-------|
| **EVD** | Extract and analyze vault data (read-only) | Ready | [EVD/USAGE.md](EVD/USAGE.md) |
| **psPAS** | Remediate accounts via the psPAS module (write) | Stages scaffolded; cmdlet reference pending | [psPAS/USAGE.md](psPAS/USAGE.md) |
| **cyberark-api** | Build/maintain a direct REST PowerShell module (write) | In development | [cyberark-api/USAGE.md](cyberark-api/USAGE.md) |
| **api-evaluation** | Per-version REST API reference library (read-only, no live calls) | In development | [api-evaluation/USAGE.md](api-evaluation/USAGE.md) |

### How they connect

```
[EVD Pipeline]                    [psPAS Pipeline]
 Ask a question                    Fix what EVD found
      |                                  |
 AI writes SQL                    AI plans changes
      |                                  |
 You run query ───> CSV data ───> You approve plan
      |                                  |
 AI checks compliance             AI executes fixes
      |                                  |
 Compliance report ──────────────> Input for psPAS
```

Most workflows start with EVD. If you just need data, you stay in EVD. If the data reveals problems that need fixing, the output feeds into psPAS.

---

## Quick Start (EVD)

1. **Set up your connection**: Open `EVD/EVD.psd1` and fill in your SQL Server names
2. **Start a conversation**: Tell the AI what vault data you need
3. **Review the SQL**: The AI generates a query and stops for your approval
4. **Run the query**: Paste the PowerShell command the AI gives you
5. **Review the data**: Check the CSV output
6. **Optional — compliance check**: The AI can analyze results against naming standards

For the full walkthrough, see [EVD/USAGE.md](EVD/USAGE.md).

---

## How the Workspace is Organized

Each pipeline is a self-contained folder. You can share or hand off a pipeline folder independently — it carries everything it needs.

```
CyberArk/
├── USAGE.md             <-- You are here
├── _config/             <-- Cross-workspace pointers (environment versions)
├── EVD/                 <-- Vault data extraction pipeline (read-only)
│   ├── USAGE.md         <-- EVD user guide
│   ├── EVD.psd1         <-- Database connection config
│   ├── scripts/         <-- Execution scripts
│   ├── references/      <-- Schema, rules, exclusions (AI reads these)
│   └── stages/          <-- The 4-stage workflow
│       ├── 01_sql_gen/
│       ├── 02_data_fetch/
│       ├── 03_parsing/
│       └── 04_remediation/
├── psPAS/               <-- Account remediation pipeline (psPAS module)
│   ├── USAGE.md
│   └── stages/
│       ├── 01_planning/
│       └── 02_execution/
├── cyberark-api/        <-- Direct REST API PowerShell module (request-driven, no fixed stages)
│   ├── USAGE.md
│   ├── module/
│   ├── references/
│   └── scripts/
└── api-evaluation/      <-- Per-version REST API reference library (no live calls)
    ├── USAGE.md
    ├── versions/
    └── references/
```

---

## Tips for New Users

- **You don't need to read the `references/` folder** — that's for the AI. Focus on the `USAGE.md` guides and the `output/` folders where results appear.
- **Review every stage** — the AI waits for your approval between stages. Take your time.
- **Start with Dev** — use `-Environment Dev` when running queries for the first time to avoid hitting production.
- **Iterate freely** — if the AI's SQL isn't quite right, just tell it what to change. You don't need to start over.
- **Ask in plain English** — "show me accounts where CPM is broken" works just as well as technical jargon.
