# User and Safe Activities Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CALog`
> **Export File**: `LogList.txt`
> **Vendor Docs**: [User and Safe Activities Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/user-and-safe-activities-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains the audit log of user and Safe activities in the Vault. Every significant action (logon, retrieve password, add account, change password, etc.) is recorded here. This is the primary table for audit and compliance queries.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | MasterID | CAAMasterID | Master record ID |
| 2 | ActivityID | CAAActivityID | Unique activity log entry ID |
| 3 | ActivityType | CAAActivityType | Type of activity (decode via CATextCodes Type 1) |
| 4 | ActivityCode | CAAActivityCode | Activity code (decode via CATextCodes Type 2) |
| 5 | Time | CAATime | Date/time of the activity |
| 6 | Action | CAAAction | Full text description of the activity performed |
| 7 | SafeID | CAASafeID | ID of the Safe involved (if applicable) |
| 8 | SafeName | CAASafeName | Name of the Safe involved |
| 9 | UserID | CAAUserID | ID of the user who performed the activity |
| 10 | UserName | CAAUserName | Name of the user who performed the activity |

---

## Common Activity Types (CATextCodes Type 1)

| Code | Activity Type |
|------|--------------|
| 1 | Logon |
| 2 | Logoff |
| 3 | Retrieve file |
| 4 | Store file |
| 5 | Delete file |
| 6 | Store password |
| 7 | Retrieve password |
| 8 | Safe management |
| 9 | User management |

> Verify exact codes against your `CATextCodes` table — codes may vary by version.

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CAUsers | CAAUserID → CAUserID | User who performed the activity |
| CASafes | CAASafeID → CASSafeID | Safe involved in the activity |
| CATextCodes | CAAActivityType → CATCCode (Type 1) | Decode activity type |
| CATextCodes | CAAActivityCode → CATCCode (Type 2) | Decode activity code |

---

## Usage Notes

- `CAAAction` is a free-text field (nvarchar(MAX)) containing the full activity description
- This table can be very large — always filter on `CAATime` for date-range queries
- `CAAActivityType` and `CAAActivityCode` are integer codes — join to `CATextCodes` for human-readable values
- Retention is controlled per-Safe (`CASLogRetentionPeriod`) and per-User (`CAULogRetentionPeriod`)

```sql
-- Example: recent password retrievals in the last 7 days
SELECT
    l.CAATime,
    l.CAAUserName,
    l.CAASafeName,
    l.CAAAction
FROM dbo.CALog l
WHERE l.CAAActivityType = 7  -- Retrieve password (verify code)
    AND l.CAATime >= DATEADD(DAY, -7, GETDATE())
ORDER BY l.CAATime DESC
```
