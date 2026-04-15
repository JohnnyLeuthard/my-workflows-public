# Safe Owners

> **Category**: Access Review
> **Tables**: dbo.CASafes, dbo.CALog
> **Requires**: —
> **Note**: The CAOwners table may not be available in all environments (see schema known gaps). This template uses CALog activity data as an alternative approach.

---

## Description

List safes with their associated users and groups based on vault activity logs. Useful for access reviews, identifying who interacts with specific safes, and auditing safe access patterns.

If your environment has the CAOwners table populated, a direct query against CAOwners is more accurate. Check the schema known gaps section in `_Schema_EVD_CyberArk_DB.md` before choosing an approach.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Safe prefix filter | *(none)* | Add `AND s.CASSafeName LIKE '...'` in WHERE | Narrow to specific safe groups |
| Activity lookback | 90 days | `DATEADD(day, -90, ...)` | How far back to look for activity |

---

## SQL — Variant A: Safe metadata with account counts

```sql
SELECT
    s.CASSafeName                   AS SafeName,
    s.CASCreatedBy                  AS CreatedBy,
    s.CASCreationDate               AS SafeCreationDate,
    s.CASLastUsed                   AS LastUsedDate,
    COUNT(DISTINCT f.CAFFileID)     AS AccountCount
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
    s.CASSafeName ASC;
```

## SQL — Variant B: Users active in each safe (from audit log)

```sql
SELECT
    l.CAASafeName                   AS SafeName,
    l.CAAUserName                   AS UserName,
    COUNT(*)                        AS ActivityCount,
    MAX(l.CAATime)                  AS LastActivityDate,
    MIN(l.CAATime)                  AS FirstActivityDate
FROM dbo.CALog l
WHERE l.CAATime >= DATEADD(day, -90, CAST(GETDATE() AS date))
    -- System safe exclusions from references/system_safe_exclusions.md -- keep in sync
    AND l.CAASafeName NOT IN (
        'System', 'VaultInternal', 'Notification', 'SharedAuth_Internal',
        'PVWAConfig', 'PVWAReports', 'PVWATicketingSystem',
        'PVWATaskDefinitions', 'PVWAPublicData',
        'PVWAUserPrefs', 'PVWAPrivateUserPrefs',
        'PSM', 'PSM-PA-', 'PSMSessions', 'PSMLiveSessions',
        'PSMNotifications', 'PSMUniversalConnectors',
        'PSMUnmanagedSessionAccounts', 'PSMPADBridgeConf', 'PSMPADBridgeCustom',
        'AppProviderConf', 'AppProviderCacheSafe',
        'AccountsFeedADAccounts', 'AccountsFeedDiscovery',
        'ConjurSync'
    )
    AND l.CAASafeName NOT LIKE 'PVWAUserPrefs-%'
    AND l.CAASafeName NOT LIKE 'PVWAPrivateUserPrefs-%'
    AND l.CAASafeName NOT LIKE 'PasswordManager%'
    AND l.CAASafeName NOT LIKE 'CPM_%_workspace'
    AND l.CAASafeName NOT LIKE 'CPM_%_Logs'
    AND l.CAASafeName NOT LIKE 'CPM_%_info'
    AND l.CAASafeName NOT LIKE 'CPM_%_info-rest'
    AND l.CAASafeName NOT LIKE 'PSMRecordings%'
GROUP BY
    l.CAASafeName, l.CAAUserName
ORDER BY
    l.CAASafeName ASC,
    ActivityCount DESC;
```

---

## Output Columns

### Variant A

| Column | Description |
|--------|-------------|
| SafeName | Safe name |
| CreatedBy | User who created the safe |
| SafeCreationDate | When the safe was created |
| LastUsedDate | Last activity timestamp on the safe |
| AccountCount | Number of active (non-deleted) password accounts in the safe |

### Variant B

| Column | Description |
|--------|-------------|
| SafeName | Safe name |
| UserName | Vault user who performed actions in this safe |
| ActivityCount | Number of log entries for this user in this safe |
| LastActivityDate | Most recent activity timestamp |
| FirstActivityDate | Earliest activity in the lookback window |
