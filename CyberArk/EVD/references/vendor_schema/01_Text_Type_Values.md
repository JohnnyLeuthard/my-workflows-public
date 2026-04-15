# Text Type Values

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CATextCodes`
> **Export File**: N/A — lookup/reference table
> **Vendor Docs**: [Text Type Values](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/text-type-values.htm)
> **Status**: Verify against live docs

---

## Description

The Text Type Values table provides human-readable text labels for numeric codes used throughout the EVD database. Many columns in other tables store integer codes (e.g., activity types, authorization levels, access types). This table maps those codes to descriptive text.

---

## Columns (Out-of-Box)

| # | Column | Description |
|---|--------|-------------|
| 1 | Type | Category of the code (e.g., activity type, authorization, access type) |
| 2 | Code | Numeric code value |
| 3 | Text | Human-readable description of the code |

---

## Common Type Categories

| Type Value | Category | Used By |
|-----------|----------|---------|
| 1 | Activity Types | CALog.CAAActivityType |
| 2 | Activity Codes | CALog.CAAActivityCode |
| 3 | User Authorizations | CAUsers.CAUAuthorizations |
| 4 | Gateway Account Authorizations | CAUsers.CAUGatewayAccountAuthorizations |
| 5 | Authentication Methods | CAUsers.CAUAuthenticationMethods |
| 6 | Safe Access Types | CASafes.CASAccessLocation |
| 7 | Request Types | CARequests.CARType |
| 8 | Request Status | CARequests.CARStatus |
| 9 | Confirmation Actions | CAConfirmations.CACAction |
| 10 | Source IDs | CAEvents.CAESourceID |
| 11 | Event Type IDs | CAEvents.CAEEventTypeID |

---

## Usage Notes

- Join to this table to decode integer columns in other EVD tables
- Example: decode activity types in `CALog`

```sql
SELECT
    l.CAATime,
    l.CAAUserName,
    l.CAASafeName,
    tc.CATCText AS ActivityType
FROM dbo.CALog l
LEFT JOIN dbo.CATextCodes tc
    ON tc.CATCType = 1
    AND tc.CATCCode = l.CAAActivityType
```
