# Stale Accounts

> **Category**: Hygiene
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: system_safe_exclusions.md (embedded below)

---

## Description

Find accounts that have not been checked out by a human user in a specified number of days. Useful for identifying unused service accounts, decommissioning candidates, or accounts that may need access review.

Accounts with no human checkout date at all (NULL) are included — these have never been used by a person.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Day threshold | 365 | `DATEADD(day, -365, ...)` | How many days of inactivity qualifies as "stale" |
| Safe prefix filter | *(none)* | Add `AND f.CAFSafeName LIKE '...'` after type filter | Narrow to specific safe groups (e.g., `'SA-%'`) |

---

## SQL

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
    f.CAFLastUsedByHuman            AS LastCheckedOutByHuman,
    f.CAFLastUsedHumanDate          AS LastCheckedOutHumanDate,
    f.CAFLastUsedByComponent        AS LastUsedByComponent,
    f.CAFLastUsedComponentDate      AS LastUsedComponentDate,
    f.CAFCreationDate               AS CreationDate
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
    -- CUSTOMIZE: change 365 to your threshold
    AND (
        f.CAFLastUsedHumanDate IS NULL
        OR f.CAFLastUsedHumanDate < DATEADD(day, -365, CAST(GETDATE() AS date))
    )
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
    f.CAFLastUsedByHuman, f.CAFLastUsedHumanDate,
    f.CAFLastUsedByComponent, f.CAFLastUsedComponentDate,
    f.CAFCreationDate
ORDER BY
    f.CAFLastUsedHumanDate ASC,
    f.CAFSafeName ASC,
    f.CAFFileName ASC;
```

---

## Output Columns

| Column | Description |
|--------|-------------|
| SafeName | Safe containing the account |
| AccountName | Account object name (CAFFileName) |
| Folder | Folder within the safe (usually "Root") |
| Address | Target machine address |
| UserName | Login username |
| PlatformID | Assigned CyberArk platform (PolicyID) |
| LastCheckedOutByHuman | User who last checked out the account |
| LastCheckedOutHumanDate | When the last human checkout occurred (NULL = never) |
| LastUsedByComponent | Last CPM/PSM component to use the account |
| LastUsedComponentDate | When the last component use occurred |
| CreationDate | When the account was onboarded to the vault |
