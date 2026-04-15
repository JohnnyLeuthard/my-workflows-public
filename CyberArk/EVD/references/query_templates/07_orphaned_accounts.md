# Orphaned Accounts

> **Category**: Hygiene
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: —

---

## Description

Find accounts that may be orphaned — missing a managing CPM platform, having no PolicyID assigned, or sitting in safes with no recent activity. Useful for vault cleanup, identifying accounts that fell through the cracks during onboarding, and pre-migration audits.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Orphan criteria | No PolicyID | HAVING clause | Change to also flag missing Address, missing UserName, etc. |
| Safe prefix filter | *(none)* | Add `AND f.CAFSafeName LIKE '...'` in WHERE | Narrow to specific safe groups |

---

## SQL — Variant A: Accounts with no platform assigned

```sql
SELECT
    f.CAFSafeName                   AS SafeName,
    f.CAFFileName                   AS AccountName,
    f.CAFFolder                     AS Folder,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'Address'
             THEN op.CAOPObjectPropertyValue END) AS Address,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'UserName'
             THEN op.CAOPObjectPropertyValue END) AS UserName,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
             THEN op.CAOPObjectPropertyValue END) AS PlatformID,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
             THEN op.CAOPObjectPropertyValue END) AS CPMDisabled,
    f.CAFCreationDate               AS CreationDate,
    f.CAFLastUsedDate               AS LastUsedDate
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
    f.CAFSafeName, f.CAFFileName, f.CAFFolder,
    f.CAFCreationDate, f.CAFLastUsedDate
-- Flag accounts with no PolicyID (no managing platform)
HAVING MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
                THEN op.CAOPObjectPropertyValue END) IS NULL
ORDER BY
    f.CAFSafeName ASC,
    f.CAFFileName ASC;
```

## SQL — Variant B: Accounts missing critical properties

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
    -- Flag which properties are missing
    CASE WHEN MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
                       THEN op.CAOPObjectPropertyValue END) IS NULL
         THEN 'Yes' ELSE 'No' END AS MissingPlatform,
    CASE WHEN MAX(CASE WHEN op.CAOPObjectPropertyName = 'Address'
                       THEN op.CAOPObjectPropertyValue END) IS NULL
         THEN 'Yes' ELSE 'No' END AS MissingAddress,
    CASE WHEN MAX(CASE WHEN op.CAOPObjectPropertyName = 'UserName'
                       THEN op.CAOPObjectPropertyValue END) IS NULL
         THEN 'Yes' ELSE 'No' END AS MissingUserName,
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
-- Flag accounts missing ANY critical property
HAVING MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
                THEN op.CAOPObjectPropertyValue END) IS NULL
    OR MAX(CASE WHEN op.CAOPObjectPropertyName = 'Address'
                THEN op.CAOPObjectPropertyValue END) IS NULL
    OR MAX(CASE WHEN op.CAOPObjectPropertyName = 'UserName'
                THEN op.CAOPObjectPropertyValue END) IS NULL
ORDER BY
    f.CAFSafeName ASC,
    f.CAFFileName ASC;
```

---

## Output Columns

### Variant A

| Column | Description |
|--------|-------------|
| SafeName | Safe containing the account |
| AccountName | Account object name |
| Folder | Folder within the safe |
| Address | Target machine address (may be NULL for orphans) |
| UserName | Login username (may be NULL for orphans) |
| PlatformID | Will always be NULL (that's the filter criteria) |
| CPMDisabled | Whether CPM is disabled on this account |
| CreationDate | When the account was onboarded |
| LastUsedDate | Last time the account was accessed |

### Variant B

| Column | Description |
|--------|-------------|
| SafeName | Safe containing the account |
| AccountName | Account object name |
| Address | Target machine address (may be NULL) |
| UserName | Login username (may be NULL) |
| PlatformID | Platform assignment (may be NULL) |
| MissingPlatform | "Yes" if PolicyID is missing |
| MissingAddress | "Yes" if Address is missing |
| MissingUserName | "Yes" if UserName is missing |
| CreationDate | When the account was onboarded |
