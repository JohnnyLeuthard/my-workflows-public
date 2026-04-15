# Stage: SQL Generation

**Job**: Translate a plain English vault data request into a valid SQL query for the EVD database.

## Inputs

- **Layer 3 (Reference)**: `references/schema.md` — Pointers to the environment DB schema and vendor schema files in `../../references/`. Start here to find the right schema reference.
- **Layer 3 (Reference)**: `../../references/naming_standards.md` — Vault naming conventions for interpreting data values.
- **Layer 3 (Reference, on-demand)**: `../../references/vendor_schema/_INDEX.md` — CyberArk out-of-box EVD report schemas. **Do not load eagerly.** Consult `_INDEX.md` first to identify the relevant report file(s), then load only those. Use when you need column descriptions, lookup code meanings, or table relationships that the environment schema does not explain.
- **Layer 3 (Reference, on-demand)**: `../../references/query_templates/_INDEX.md` — Pre-built SQL for common queries. **Do not load eagerly.** Consult `_INDEX.md` first. Use when the user's request matches a known pattern (stale accounts, CPM health, inventory, etc.).
- **Layer 3 (Reference, on-demand)**: `../../references/datetime_handling.md` — Epoch conversion patterns and known field formats. **Load when the query involves datetime filtering or display** on CAObjectProperties date fields (e.g., LastSuccessChange, LastFailDate).
- **Layer 3 (Reference, on-demand)**: `../../references/system_safe_exclusions.md` — System safe exclusion filters. **Apply by default** to any query filtering on CAFiles or CASafes. Skip only when the user explicitly requests system safes.
- **Layer 4 (Working)**: The current user query from the chat session.

## Process

1. Analyze the user's request against the table schema in `references/schema.md`.
2. Identify the necessary tables, JOIN operations, and column filters.
3. Apply naming convention context from `naming_standards.md` to interpret expected values.
4. Generate a single, optimized SQL query.

## Outputs

- `query.sql` → `output/query.sql`

## Review Gate

Stop after generating the SQL. The human reviews and may edit `output/query.sql` before the data fetch stage runs.
