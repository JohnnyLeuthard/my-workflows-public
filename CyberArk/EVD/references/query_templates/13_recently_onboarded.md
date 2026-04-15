# Recently Onboarded Accounts

> **Category**: Inventory
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: —
> **Note**: `CAFCreationDate` is a native datetime column — no epoch conversion needed. `LastSuccessChange` in `CAObjectProperties` is a Unix epoch integer; the epoch conversion below shows whether CPM has completed its first password change.

---

## Description

Find accounts onboarded to the vault in the last N days. Useful for onboarding audits, post-migration verification, and confirming that newly created accounts follow naming standards before the first compliance review. The `FirstPasswordChange` column indicates whether CPM has successfully rotated the password since onboarding.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Lookback window | 30 days | `DATEADD(day, -30, ...)` on `CAFCreationDate` | How many days back to consider "recently onboarded" |
| Safe prefix filter | *(none)* | Add `AND f.CAFSafeName LIKE '...'` | Narrow to a specific safe group |
| Creation method filter | All | Add `HAVING CreationMethod = '...'` | Restrict to specific onboarding method (e.g., manual vs. automated) |

---

## SQL

```sql
SELECT
    f.CAFSafeName                   AS SafeName,
    f.CAFFileName                   AS AccountName,
    f.CAFCreatedBy                  AS OnboardedBy,
    f.CAFCreationDate               AS OnboardedDate,
    DATEDIFF(day, f.CAFCreationDate, GETDATE())
                                    AS DaysOld,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'Address'
             THEN op.CAOPObjectPropertyValue END) AS Address,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'UserName'
             THEN op.CAOPObjectPropertyValue END) AS UserName,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
             THEN op.CAOPObjectPropertyValue END) AS PlatformID,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CreationMethod'
             THEN op.CAOPObjectPropertyValue END) AS CreationMethod,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
             THEN op.CAOPObjectPropertyValue END) AS CPMDisabled,
    -- Convert epoch to datetime to show whether CPM has run its first password change
    DATEADD(second,
        TRY_CAST(
            MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastSuccessChange'
                     THEN op.CAOPObjectPropertyValue END) AS bigint
        ),
        '1970-01-01'
    )                               AS FirstPasswordChange
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
    -- CUSTOMIZE: change 30 to your lookback window
    AND f.CAFCreationDate >= DATEADD(day, -30, CAST(GETDATE() AS date))
    -- CUSTOMIZE: add safe prefix filter
    -- AND f.CAFSafeName LIKE 'SA-%'
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
    f.CAFSafeName,
    f.CAFFileName,
    f.CAFCreatedBy,
    f.CAFCreationDate
-- CUSTOMIZE: uncomment to filter by creation method
-- HAVING MAX(CASE WHEN op.CAOPObjectPropertyName = 'CreationMethod'
--                 THEN op.CAOPObjectPropertyValue END) = 'PVWA'
ORDER BY
    f.CAFCreationDate DESC,
    f.CAFSafeName ASC,
    f.CAFFileName ASC;
```

---

## Output Columns

| Column | Description |
|--------|-------------|
| SafeName | Safe containing the account |
| AccountName | Account object name |
| OnboardedBy | Vault username who created the account |
| OnboardedDate | Date and time the account was onboarded |
| DaysOld | Computed days since onboarding |
| Address | Target machine address |
| UserName | Login username |
| PlatformID | Assigned CyberArk platform (PolicyID) |
| CreationMethod | How the account was created (e.g., PVWA, REST, CPM discovery) |
| CPMDisabled | Whether CPM management is disabled on this account |
| FirstPasswordChange | Datetime of first successful CPM password change (NULL = CPM has not run yet) |
