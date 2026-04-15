# EVD — Datetime Field Handling

> On-demand reference. Load this file when writing or reviewing queries that filter or display datetime fields.
> Do **not** pre-load — open only when datetime handling is relevant.

---

## Core Rules

1. **Assume UTC** for all datetime values unless there is explicit evidence otherwise.
2. **Datetime fields are not guaranteed to be human-readable.**
   `CAObjectProperties` stores some dates as raw integers or strings.
3. **Always check this file** before filtering on a CAObjectProperties date field to avoid silent errors.

---

## How to Detect the Format

Run a quick diagnostic to inspect raw values:

```sql
SELECT TOP 10 op.CAOPObjectPropertyValue
FROM dbo.CAObjectProperties op
JOIN dbo.CAFiles f
    ON op.CAOPFileId = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeId = f.CAFSafeID
WHERE op.CAOPObjectPropertyName = '<PropertyName>'
ORDER BY op.CAOPObjectPropertyValue DESC;
```

### Interpretation Guide

| What you see | Format | Conversion strategy |
|---|---|---|
| `1773608521` | Unix epoch (seconds since 1970-01-01 UTC) | Use epoch pattern below |
| `2026-03-16 10:45:00` | Human-readable datetime | `TRY_CONVERT(datetime, value)` |
| `2026-03-16` | Date only | `TRY_CONVERT(date, value)` |

---

## Epoch Conversion Pattern

Use this when the field is a 10-digit integer stored as `nvarchar`.

```sql
-- Convert to datetime (UTC)
DATEADD(
    second,
    TRY_CAST(op.CAOPObjectPropertyValue AS bigint),
    '1970-01-01'
)
```

**Example**: filter accounts with `LastSuccessChange` in last 90 days:

```sql
HAVING DATEADD(
    second,
    TRY_CAST(
        MAX(CASE
            WHEN op.CAOPObjectPropertyName = 'LastSuccessChange'
            THEN op.CAOPObjectPropertyValue
        END) AS bigint
    ),
    '1970-01-01'
) >= DATEADD(day, -90, CAST(GETDATE() AS date))
```

`TRY_CAST` returns `NULL` for bad values instead of failing. This is preferred behavior.

---

## Known Field Formats

### CAObjectProperties (EAV — stored as nvarchar)

| Property Name | Format | Notes |
|---|---|---|
| LastSuccessChange | Unix epoch (integer) | Confirmed 2026-03-16 |
| LastSuccessVerification | Likely Unix epoch | Same CPM subsystem |
| LastSuccessReconciliation | Likely Unix epoch | Same CPM subsystem |
| LastFailDate | Likely Unix epoch | Treat as epoch until proven otherwise |
| NextPeriodicChangeSearch | Likely Unix epoch | Scheduled field |
| NextPeriodicVerifySearch | Likely Unix epoch | Scheduled field |
| PSMStartTime | Unknown | May be human-readable |
| PSMEndTime | Unknown | May be human-readable |

When confirmed, update this table. Do not assume consistency across fields.

### Native Table Columns (typed as datetime — no conversion needed)

These columns are real `datetime` type in the database. Safe for direct filtering and comparison.

| Table | Columns |
|---|---|
| dbo.CAFiles | CAFCreationDate, CAFLastUsedDate, CAFDeletionDate |
| dbo.CASafes | CASLastUsed |
| dbo.CAUsers | CAUCreationDate, CAULastLogonDate |
| dbo.CAEvents | CAECreationDate |
