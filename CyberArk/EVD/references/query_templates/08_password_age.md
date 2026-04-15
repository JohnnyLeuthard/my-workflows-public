# Password Age

> **Category**: Operations
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: datetime_handling.md (LastSuccessChange is stored as Unix epoch)

---

## Description

Find accounts where the password has not been successfully changed in a specified number of days. Useful for identifying overdue rotations, verifying CPM is functioning, and pre-audit password compliance checks.

The `LastSuccessChange` property is stored as a Unix epoch integer in CAObjectProperties. This template handles the conversion automatically.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Day threshold | 90 | `DATEADD(day, -90, ...)` | Maximum acceptable password age in days |
| Safe prefix filter | *(none)* | Add `AND f.CAFSafeName LIKE '...'` in WHERE | Narrow to specific safe groups |
| Include never-changed | Yes | `OR ... IS NULL` in HAVING | Whether to include accounts with no change history |

---

## SQL

```sql
SELECT
    f.CAFSafeName                   AS SafeName,
    f.CAFFileName                   AS AccountName,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'Address'
             THEN op.CAOPObjectPropertyValue END) AS Address,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'UserName'
             THEN op.CAOPObjectPropertyValue END) AS UserName,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
             THEN op.CAOPObjectPropertyValue END) AS PlatformID,
    -- Convert LastSuccessChange from Unix epoch to datetime
    DATEADD(second,
        TRY_CAST(
            MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastSuccessChange'
                     THEN op.CAOPObjectPropertyValue END) AS bigint
        ),
        '1970-01-01'
    ) AS LastSuccessChange,
    -- Calculate password age in days
    DATEDIFF(day,
        DATEADD(second,
            TRY_CAST(
                MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastSuccessChange'
                         THEN op.CAOPObjectPropertyValue END) AS bigint
            ),
            '1970-01-01'
        ),
        GETDATE()
    ) AS PasswordAgeDays,
    -- Convert LastSuccessVerification from Unix epoch
    DATEADD(second,
        TRY_CAST(
            MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastSuccessVerification'
                     THEN op.CAOPObjectPropertyValue END) AS bigint
        ),
        '1970-01-01'
    ) AS LastSuccessVerification,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
             THEN op.CAOPObjectPropertyValue END) AS CPMDisabled,
    f.CAFCreationDate               AS CreationDate
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
    -- System safe exclusions from references/system_safe_exclusions.md -- keep in sync
    -- Vault Infrastructure
    AND f.CAFSafeName NOT IN (
        'System', 'VaultInternal', 'Notification', 'SharedAuth_Internal'
    )
    -- PVWA
    AND f.CAFSafeName NOT IN (
        'PVWAConfig', 'PVWAReports', 'PVWATicketingSystem',
        'PVWATaskDefinitions', 'PVWAPublicData',
        'PVWAUserPrefs', 'PVWAPrivateUserPrefs'
    )
    AND f.CAFSafeName NOT LIKE 'PVWAUserPrefs-%'
    AND f.CAFSafeName NOT LIKE 'PVWAPrivateUserPrefs-%'
    -- CPM
    AND f.CAFSafeName NOT LIKE 'PasswordManager%'
    AND f.CAFSafeName NOT LIKE 'CPM_%_workspace'
    AND f.CAFSafeName NOT LIKE 'CPM_%_Logs'
    AND f.CAFSafeName NOT LIKE 'CPM_%_info'
    AND f.CAFSafeName NOT LIKE 'CPM_%_info-rest'
    -- PSM
    AND f.CAFSafeName NOT IN (
        'PSM', 'PSM-PA-', 'PSMSessions', 'PSMLiveSessions',
        'PSMNotifications', 'PSMUniversalConnectors',
        'PSMUnmanagedSessionAccounts', 'PSMPADBridgeConf', 'PSMPADBridgeCustom'
    )
    AND f.CAFSafeName NOT LIKE 'PSMRecordings%'
    -- AAM
    AND f.CAFSafeName NOT IN ('AppProviderConf', 'AppProviderCacheSafe')
    -- Discovery
    AND f.CAFSafeName NOT IN ('AccountsFeedADAccounts', 'AccountsFeedDiscovery')
    -- Conjur
    AND f.CAFSafeName NOT IN ('ConjurSync')
GROUP BY
    f.CAFSafeName, f.CAFFileName, f.CAFCreationDate
-- CUSTOMIZE: change 90 to your threshold
HAVING (
    -- Password changed more than 90 days ago
    DATEADD(second,
        TRY_CAST(
            MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastSuccessChange'
                     THEN op.CAOPObjectPropertyValue END) AS bigint
        ),
        '1970-01-01'
    ) < DATEADD(day, -90, CAST(GETDATE() AS date))
    -- OR password has never been changed
    OR MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastSuccessChange'
                THEN op.CAOPObjectPropertyValue END) IS NULL
)
ORDER BY
    LastSuccessChange ASC,
    f.CAFSafeName ASC,
    f.CAFFileName ASC;
```

---

## Output Columns

| Column | Description |
|--------|-------------|
| SafeName | Safe containing the account |
| AccountName | Account object name |
| Address | Target machine address |
| UserName | Login username |
| PlatformID | Assigned CyberArk platform |
| LastSuccessChange | When the password was last successfully changed (converted from epoch; NULL = never) |
| PasswordAgeDays | Days since last successful change (NULL = never changed) |
| LastSuccessVerification | When the password was last successfully verified (converted from epoch) |
| CPMDisabled | Non-empty = CPM is disabled on this account |
| CreationDate | When the account was onboarded to the vault |
