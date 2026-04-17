# Stage: Data Fetch

**Job**: Execute the verified SQL query against the EVD database and export results to CSV.

## Inputs

- **Layer 4 (Working)**: `stages/01_sql_gen/output/query.sql` — The SQL query generated and approved in Stage 1 (absolute path from EVD folder root).
- **Layer 3 (Reference)**: `EVD.psd1` — EVD database connection configuration for Dev/UAT/Prod environments, located in the EVD folder root.

## Process

### Execution Method

The SQL query must be executed via the PowerShell script. You have two options:

**Option A: User runs the script manually** (recommended for initial setup)
```powershell
# From the EVD folder, run:
. .\scripts\Invoke-EVDQuery.ps1
Invoke-EVDQuery -SQLFile '.\stages\01_sql_gen\output\query.sql' -ExportPath '.\stages\02_data_fetch\output\vault_data.csv'

# For non-Prod environments, add: -Environment Dev  or  -Environment UAT
Invoke-EVDQuery -SQLFile '.\stages\01_sql_gen\output\query.sql' -ExportPath '.\stages\02_data_fetch\output\vault_data.csv' -Environment UAT
```

**Option B: AI agent executes the script** (if running in an agent-enabled terminal)
The agent will run the equivalent command in a terminal and report the results.

### Execution Details

1. The script:
   - Loads connection settings from EVD.psd1 (server names, database, etc.)
   - Reads the approved SQL query from `stages/01_sql_gen/output/query.sql`
   - Connects to the target EVD database using Windows Integrated Security
   - Executes the query
   - Exports all results to CSV format

2. Output goes to the exact path specified: `stages/02_data_fetch/output/vault_data.csv`

3. The script displays a summary showing row count and execution time

## Outputs

- **CSV data export** → `stages/02_data_fetch/output/vault_data.csv` (absolute path from EVD folder root)

## Review Gate

Stop here. Inspect the CSV file (`stages/02_data_fetch/output/vault_data.csv`) to verify the data retrieval was successful and accurate before the parsing stage begins.
