# CPM Health

> **Category**: Operations
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: datetime_handling.md (for LastFailDate epoch conversion)

---

## Description

Find accounts where the Central Policy Manager (CPM) is disabled, has encountered errors, or has not successfully changed the password. Useful for CPM operations review, identifying accounts that need manual intervention, and tracking CPM error trends.

CPMDisabled is a boolean-style property — presence of any non-empty value means disabled. See `eva_query_patterns.md` for the boolean property pattern.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Filter mode | CPM disabled only | HAVING clause | Change to include error states or all CPM issues |
| Safe prefix filter | *(none)* | Add `AND f.CAFSafeName LIKE '...'` after type filter | Narrow to specific safe groups |

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
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
             THEN op.CAOPObjectPropertyValue END) AS CPMDisabled,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMStatus'
             THEN op.CAOPObjectPropertyValue END) AS CPMStatus,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMErrorDetails'
             THEN op.CAOPObjectPropertyValue END) AS CPMErrorDetails,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'RetriesCount'
             THEN op.CAOPObjectPropertyValue END) AS RetriesCount,
    -- LastFailDate is stored as Unix epoch — convert to datetime
    DATEADD(second,
        TRY_CAST(
            MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastFailDate'
                     THEN op.CAOPObjectPropertyValue END) AS bigint
        ),
        '1970-01-01'
    ) AS LastFailDate,
    -- LastSuccessChange is stored as Unix epoch — convert to datetime
    DATEADD(second,
        TRY_CAST(
            MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastSuccessChange'
                     THEN op.CAOPObjectPropertyValue END) AS bigint
        ),
        '1970-01-01'
    ) AS LastSuccessChange,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'LastTask'
             THEN op.CAOPObjectPropertyValue END) AS LastTask
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
    f.CAFSafeName, f.CAFFileName
-- CUSTOMIZE: adjust HAVING to change what "unhealthy" means
-- Option A (default): CPM disabled accounts only
HAVING MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
                THEN op.CAOPObjectPropertyValue END) IS NOT NULL
   AND MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
                THEN op.CAOPObjectPropertyValue END) <> ''
-- Option B: CPM disabled OR has errors (uncomment to use)
-- HAVING (
--     (MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
--               THEN op.CAOPObjectPropertyValue END) IS NOT NULL
--      AND MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
--               THEN op.CAOPObjectPropertyValue END) <> '')
--     OR MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMStatus'
--                  THEN op.CAOPObjectPropertyValue END) = 'failure'
-- )
ORDER BY
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
| CPMDisabled | Non-empty = CPM is disabled; reason text may vary |
| CPMStatus | Last CPM operation status (e.g., "success", "failure") |
| CPMErrorDetails | Error message from the last failed CPM operation |
| RetriesCount | Number of consecutive CPM retry attempts |
| LastFailDate | When the last CPM failure occurred (converted from epoch) |
| LastSuccessChange | When the password was last successfully changed (converted from epoch) |
| LastTask | Last CPM task type (e.g., "change", "verify", "reconcile") |
