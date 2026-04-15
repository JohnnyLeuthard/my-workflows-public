# Safe Summary

> **Category**: Inventory
> **Tables**: dbo.CASafes, dbo.CAFiles
> **Requires**: —

---

## Description

Per-safe rollup showing account counts, creation date, last activity, and age metrics. Useful for vault health dashboards, capacity reviews, and identifying empty or inactive safes.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Safe prefix filter | *(none)* | Add `AND s.CASSafeName LIKE '...'` in WHERE | Narrow to specific safe groups |
| Minimum account count | 0 (all safes) | Add `HAVING COUNT(f.CAFFileID) >= N` | Exclude safes below a threshold |

---

## SQL

```sql
SELECT
    s.CASSafeName                   AS SafeName,
    s.CASCreatedBy                  AS CreatedBy,
    s.CASCreationDate               AS SafeCreationDate,
    s.CASLastUsed                   AS LastUsedDate,
    DATEDIFF(day, s.CASCreationDate, GETDATE()) AS SafeAgeDays,
    COUNT(f.CAFFileID)              AS AccountCount,
    MIN(f.CAFCreationDate)          AS OldestAccountDate,
    MAX(f.CAFCreationDate)          AS NewestAccountDate,
    MAX(f.CAFLastUsedDate)          AS LastAccountActivity
FROM dbo.CASafes s
LEFT JOIN dbo.CAFiles f
    ON f.CAFSafeID = s.CASSafeID
    AND f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
WHERE 1 = 1
    -- System safe exclusions from references/system_safe_exclusions.md -- keep in sync
    -- Vault Infrastructure
    AND s.CASSafeName NOT IN (
        'System', 'VaultInternal', 'Notification', 'SharedAuth_Internal'
    )
    -- PVWA
    AND s.CASSafeName NOT IN (
        'PVWAConfig', 'PVWAReports', 'PVWATicketingSystem',
        'PVWATaskDefinitions', 'PVWAPublicData',
        'PVWAUserPrefs', 'PVWAPrivateUserPrefs'
    )
    AND s.CASSafeName NOT LIKE 'PVWAUserPrefs-%'
    AND s.CASSafeName NOT LIKE 'PVWAPrivateUserPrefs-%'
    -- CPM
    AND s.CASSafeName NOT LIKE 'PasswordManager%'
    AND s.CASSafeName NOT LIKE 'CPM_%_workspace'
    AND s.CASSafeName NOT LIKE 'CPM_%_Logs'
    AND s.CASSafeName NOT LIKE 'CPM_%_info'
    AND s.CASSafeName NOT LIKE 'CPM_%_info-rest'
    -- PSM
    AND s.CASSafeName NOT IN (
        'PSM', 'PSM-PA-', 'PSMSessions', 'PSMLiveSessions',
        'PSMNotifications', 'PSMUniversalConnectors',
        'PSMUnmanagedSessionAccounts', 'PSMPADBridgeConf', 'PSMPADBridgeCustom'
    )
    AND s.CASSafeName NOT LIKE 'PSMRecordings%'
    -- AAM
    AND s.CASSafeName NOT IN ('AppProviderConf', 'AppProviderCacheSafe')
    -- Discovery
    AND s.CASSafeName NOT IN ('AccountsFeedADAccounts', 'AccountsFeedDiscovery')
    -- Conjur
    AND s.CASSafeName NOT IN ('ConjurSync')
GROUP BY
    s.CASSafeName, s.CASCreatedBy, s.CASCreationDate, s.CASLastUsed
ORDER BY
    AccountCount DESC,
    s.CASSafeName ASC;
```

---

## Output Columns

| Column | Description |
|--------|-------------|
| SafeName | Safe name |
| CreatedBy | User who created the safe |
| SafeCreationDate | When the safe was created |
| LastUsedDate | Last activity timestamp on the safe (from CASafes) |
| SafeAgeDays | Days since the safe was created |
| AccountCount | Number of active (non-deleted) password accounts |
| OldestAccountDate | Creation date of the oldest account in the safe |
| NewestAccountDate | Creation date of the most recently onboarded account |
| LastAccountActivity | Most recent LastUsedDate across all accounts in the safe |
