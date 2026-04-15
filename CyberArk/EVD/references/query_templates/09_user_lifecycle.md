# User Lifecycle

> **Category**: Access Review
> **Tables**: dbo.CAUsers
> **Requires**: —
> **Note**: `CAUDisabled` is nvarchar — treat the value `'yes'` as disabled. `CAULastLogonDate` is a native datetime column; no epoch conversion needed. `CAUExternalInternal` = 0 for internal vault users, 1 for LDAP/external users.

---

## Description

Find vault users who are disabled, have never logged in, have an expired account, or have not logged in within a specified number of days. Useful for access certification reviews, identifying stale service or admin accounts, and ensuring disabled users cannot reach the vault.

This query covers the human identity layer above accounts — who can authenticate to the vault, not which accounts they can access.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Inactivity threshold | 90 | `DATEADD(day, -90, ...)` | Days since last logon to classify as inactive |
| Include disabled users | Yes | Remove `OR u.CAUDisabled = 'yes'` to exclude | Whether to return users flagged as disabled |
| Include expired users | Yes | Remove the `CAUExpirationDate` condition to exclude | Whether to return users with a past expiration date |
| Location filter | *(none)* | Add `AND u.CALocationName = '...'` | Restrict to a specific vault location or directory |

---

## SQL — Variant A (Full Detail)

```sql
SELECT
    u.CAUserName                    AS VaultUserName,
    u.CAUFirstName                  AS FirstName,
    u.CAULastName                   AS LastName,
    u.CAUBusinessEmail              AS Email,
    u.CALocationName                AS Location,
    u.CAUDisabled                   AS Disabled,
    u.CAUExternalInternal           AS UserType,    -- 0 = internal vault, 1 = LDAP/external
    u.CAULastLogonDate              AS LastLogonDate,
    u.CAUPrevLogonDate              AS PrevLogonDate,
    DATEDIFF(day, u.CAULastLogonDate, GETDATE())
                                    AS DaysSinceLogon,
    u.CAUExpirationDate             AS ExpirationDate,
    u.CAUCreationDate               AS CreationDate,
    CASE
        WHEN u.CAUDisabled = 'yes'
            THEN 'Disabled'
        WHEN u.CAUExpirationDate IS NOT NULL
            AND u.CAUExpirationDate < GETDATE()
            THEN 'Expired'
        WHEN u.CAULastLogonDate IS NULL
            THEN 'Never Logged In'
        ELSE 'Inactive'
    END                             AS Status
FROM dbo.CAUsers u
WHERE
    -- CUSTOMIZE: change 90 to your inactivity threshold
    u.CAULastLogonDate < DATEADD(day, -90, CAST(GETDATE() AS date))
    OR u.CAULastLogonDate IS NULL
    OR u.CAUDisabled = 'yes'
    OR (
        u.CAUExpirationDate IS NOT NULL
        AND u.CAUExpirationDate < GETDATE()
    )
    -- CUSTOMIZE: uncomment to filter to a specific location or directory
    -- AND u.CALocationName = 'YourLocation'
ORDER BY
    Status ASC,
    u.CAULastLogonDate ASC,
    u.CAUserName ASC;
```

---

## SQL — Variant B (Summary Count by Status)

```sql
SELECT
    CASE
        WHEN u.CAUDisabled = 'yes'
            THEN 'Disabled'
        WHEN u.CAUExpirationDate IS NOT NULL
            AND u.CAUExpirationDate < GETDATE()
            THEN 'Expired'
        WHEN u.CAULastLogonDate IS NULL
            THEN 'Never Logged In'
        ELSE 'Inactive'
    END                             AS Status,
    COUNT(*)                        AS UserCount
FROM dbo.CAUsers u
WHERE
    -- CUSTOMIZE: change 90 to your inactivity threshold
    u.CAULastLogonDate < DATEADD(day, -90, CAST(GETDATE() AS date))
    OR u.CAULastLogonDate IS NULL
    OR u.CAUDisabled = 'yes'
    OR (
        u.CAUExpirationDate IS NOT NULL
        AND u.CAUExpirationDate < GETDATE()
    )
GROUP BY
    CASE
        WHEN u.CAUDisabled = 'yes'
            THEN 'Disabled'
        WHEN u.CAUExpirationDate IS NOT NULL
            AND u.CAUExpirationDate < GETDATE()
            THEN 'Expired'
        WHEN u.CAULastLogonDate IS NULL
            THEN 'Never Logged In'
        ELSE 'Inactive'
    END
ORDER BY
    UserCount DESC;
```

---

## Output Columns

### Variant A

| Column | Description |
|--------|-------------|
| VaultUserName | Vault login name |
| FirstName | First name |
| LastName | Last name |
| Email | Business email address |
| Location | Vault location (maps to LDAP directory or local) |
| Disabled | Raw CAUDisabled value — `'yes'` means disabled |
| UserType | 0 = internal vault user, 1 = LDAP/external |
| LastLogonDate | Most recent successful logon (NULL = never logged in) |
| PrevLogonDate | Previous logon before the most recent |
| DaysSinceLogon | Computed days since last logon (NULL if never logged in) |
| ExpirationDate | Account expiration date (NULL = no expiry set) |
| CreationDate | When the vault user account was created |
| Status | Computed: Disabled / Expired / Never Logged In / Inactive |

### Variant B

| Column | Description |
|--------|-------------|
| Status | Computed status category |
| UserCount | Number of users in that status category |
