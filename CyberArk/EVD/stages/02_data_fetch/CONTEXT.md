# Stage: Data Fetch

**Job**: Execute the verified SQL query against the EVD database and export results to CSV.

## Inputs

- **Layer 4 (Working)**: `../01_sql_gen/output/query.sql` — The SQL query from the previous stage.
- **Layer 3 (Reference)**: `../../EVD.psd1` — EVD database connection configuration (Dev/UAT/Prod environments).

## Process

1. Invoke `../../scripts/Invoke-EVDQuery.ps1` with the SQL file and export path:
   ```powershell
   Invoke-EVDQuery -SQLFile '../01_sql_gen/output/query.sql' -ExportPath 'output/vault_data.csv'
   ```
2. The script connects to the target database using settings from `EVD.psd1` and executes the query.
3. Results are exported as a plain-text CSV file to the output path.

## Outputs

- `vault_data.csv` → `output/vault_data.csv`

## Review Gate

Stop here. Inspect `output/vault_data.csv` to verify the data retrieval was successful and accurate before the parsing stage begins.
