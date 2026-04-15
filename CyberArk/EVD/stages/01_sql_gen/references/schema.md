# EVD Database Schema — Reference Pointers

> This file points to the Layer 3 schema references in `EVD/references/`. Do not duplicate schema content here.

## Environment Schema (Primary — use for SQL generation)

These define the actual column types, lengths, and table structures in the environment's EVD database. **Always use these for generating SQL.**

- **Full DB schema**: [`_Schema_EVD_CyberArk_DB.md`](../../../references/_Schema_EVD_CyberArk_DB.md) — All EVD tables with columns, data types, lengths, nullability, and key relationships.
- **EAV property catalog**: [`_Schema_EVD_CAOObjectProperties_Table.md`](../../../references/_Schema_EVD_CAOObjectProperties_Table.md) — Known property names for the CAObjectProperties EAV table, plus the standard JOIN pattern.

## Datetime Handling (On-demand — load when filtering on date fields)

- **Datetime reference**: [`datetime_handling.md`](../../../references/datetime_handling.md) — Epoch conversion patterns, known field formats, and native datetime columns. Load this when the query involves date filtering on CAObjectProperties fields (e.g., LastSuccessChange, LastFailDate).

## System Safe Exclusions (On-demand — load when querying safes)

- **Safe exclusion list**: [`system_safe_exclusions.md`](../../../references/system_safe_exclusions.md) — Default system safe filters for EVD queries. Load when the query touches CAFiles or CASafes. **Exclude by default**; skip only when the user explicitly requests system safes.

## Vendor Schema (Supplementary — use for understanding column meanings)

Out-of-box CyberArk EVD report definitions. Use these when you need to understand what a column means, what values it holds, or how to decode integer codes via CATextCodes.

- **Index**: [`vendor_schema/_INDEX.md`](../../../references/vendor_schema/_INDEX.md) — Start here. Maps each report to its DB table and file. Load only the specific report file(s) relevant to the current query.

### Loading rules

1. Environment schema takes precedence for types, lengths, and column names
2. Vendor schema explains semantics — what columns mean, valid values, table relationships
3. Do NOT load all 15 vendor files — consult `_INDEX.md`, then load only what you need
