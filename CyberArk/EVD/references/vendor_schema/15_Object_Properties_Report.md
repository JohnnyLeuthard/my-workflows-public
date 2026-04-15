# Object Properties Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CAObjectProperties`
> **Export File**: `ObjectProperties.txt`
> **Vendor Docs**: [Object Properties Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/object-properties-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains the extended properties (metadata) for all file/account objects stored in Vault Safes. This is an **EAV (Entity-Attribute-Value)** table — each row stores one property name-value pair for one account. This is where most account-level metadata lives (Address, UserName, Platform, CPM status, etc.).

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | SafeID | CAOPSafeID | ID of the Safe containing the object |
| 2 | FileID | CAOPFileID | ID of the file/account object |
| 3 | PropertyName | CAOPObjectPropertyName | Name of the property |
| 4 | PropertyValue | CAOPObjectPropertyValue | Value of the property |
| 5 | VaultID | CAOPVaultID | Vault instance identifier |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CAFiles | CAOPFileID → CAST(CAFFileID AS int) AND CAOPSafeID → CAFSafeID | The parent file/account |
| CASafes | CAOPSafeID → CASSafeID | The containing Safe |

---

## Join Pattern

```sql
SELECT
    f.CAFFileName,
    f.CAFSafeName,
    op.CAOPObjectPropertyValue
FROM dbo.CAFiles f
JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE op.CAOPObjectPropertyName = 'Address'
    AND f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
```

---

## Usage Notes

- This is the most-queried EVD table after CAFiles
- Always filter on `CAOPObjectPropertyName` to get specific properties
- For a complete list of known property names organized by category, see: [_Schema_EVD_CAOObjectProperties_Table.md](../_Schema_EVD_CAOObjectProperties_Table.md)
- The `CAOPFileID` column is `int` while `CAFFileID` is `bigint` — use `CAST(CAFFileID AS int)` in joins
- Multiple properties per account means pivoting is needed for flat reports:

```sql
-- Pivot common properties into columns
SELECT
    f.CAFFileName,
    f.CAFSafeName,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'Address' THEN op.CAOPObjectPropertyValue END) AS Address,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'UserName' THEN op.CAOPObjectPropertyValue END) AS UserName,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID' THEN op.CAOPObjectPropertyValue END) AS Platform,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMStatus' THEN op.CAOPObjectPropertyValue END) AS CPMStatus
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
GROUP BY f.CAFFileName, f.CAFSafeName
```
