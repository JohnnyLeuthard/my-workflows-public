# Stage: SQL Generation

**Job**: Translate a plain English vault data request into a valid SQL query for the EVD database.

## Inputs

- **Layer 3 (Reference, primary)**: `../../references/_Schema_EVD_CyberArk_DB.md` — Core database schema defining all tables, columns, types, and relationships for the CyberArk EVD database. **Start here for any table or column lookup.**
- **Layer 3 (Reference, supplementary)**: `../../references/_Schema_EVD_CAOObjectProperties_Table.md` — Entity-Attribute-Value (EAV) pattern details for the CAObjectProperties pivot table, including how to query date/boolean properties. **Load when writing queries that pivot CAObjectProperties.**
- **Layer 3 (Reference)**: `../../references/naming_standards.md` — Vault naming conventions for interpreting expected account/safe name patterns in your query filters.
- **Layer 3 (Reference, on-demand)**: `../../references/vendor_schema/_INDEX.md` — CyberArk out-of-box EVD report schemas. **Do not load eagerly.** Consult the index first to identify the relevant report file(s), then load only those. Use when you need column descriptions, lookup code meanings, or table relationships beyond the environment schema.
- **Layer 3 (Reference, on-demand)**: `../../references/query_templates/_INDEX.md` — Pre-built SQL for common queries. **Do not load eagerly.** Consult the index first. Use when the user's request matches a known pattern (stale accounts, CPM health, inventory, etc.).
- **Layer 3 (Reference, on-demand)**: `../../references/datetime_handling.md` — Epoch conversion patterns and known field formats. **Load when the query involves datetime filtering or display** on CAObjectProperties date fields (e.g., LastSuccessChange, LastFailDate).
- **Layer 3 (Reference, on-demand)**: `../../references/system_safe_exclusions.md` — System safe exclusion filters. **Apply by default** to any query filtering on CAFiles or CASafes. Skip only when the user explicitly requests system safes.
- **Layer 4 (Working)**: The current user query from the chat session.

## Process

1. Analyze the user's request against the table schema in `../../references/_Schema_EVD_CyberArk_DB.md`.
2. Identify the necessary tables, JOIN operations, and column filters.
3. Apply naming convention context from `../../references/naming_standards.md` to interpret expected values.
4. Generate a single, optimized SQL query.

## Outputs

- **SQL query** → `stages/01_sql_gen/output/query.sql` (absolute path from EVD folder root)

## Review Gate

Stop after generating the SQL. The human reviews and may edit the file before the data fetch stage runs.
