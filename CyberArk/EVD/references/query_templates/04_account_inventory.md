# Account Inventory

> **Category**: Inventory
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: —

---

## Description

Count accounts grouped by safe, platform, address domain, or any combination. Useful for capacity planning, onboarding audits, and understanding vault composition at a glance.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Group dimension | Safe + Platform | GROUP BY clause | Change to group by safe only, platform only, or add address |
| Safe prefix filter | *(none)* | Add `AND f.CAFSafeName LIKE '...'` in WHERE | Narrow to specific safe groups |

---

## SQL — Variant A: Counts by safe and platform

```sql
SELECT
    f.CAFSafeName                   AS SafeName,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
             THEN op.CAOPObjectPropertyValue END) AS PlatformID,
    COUNT(DISTINCT f.CAFFileID)     AS AccountCount
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
    f.CAFSafeName, f.CAFFileID
HAVING 1 = 1
ORDER BY
    SafeName ASC;
```

> **Note**: The above query groups by CAFFileID to correctly pivot the EAV property, then the outer result gives one row per account with its platform. For a true safe-by-platform count, wrap in a subquery:

```sql
SELECT
    SafeName,
    PlatformID,
    COUNT(*) AS AccountCount
FROM (
    SELECT
        f.CAFSafeName               AS SafeName,
        f.CAFFileID,
        MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
                 THEN op.CAOPObjectPropertyValue END) AS PlatformID
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
        f.CAFSafeName, f.CAFFileID
) sub
GROUP BY
    SafeName, PlatformID
ORDER BY
    SafeName ASC,
    AccountCount DESC;
```

---

## SQL — Variant B: Total counts by safe only

```sql
SELECT
    f.CAFSafeName                   AS SafeName,
    COUNT(*)                        AS AccountCount
FROM dbo.CAFiles f
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
    f.CAFSafeName
ORDER BY
    AccountCount DESC;
```

---

## Output Columns

### Variant A (safe + platform)

| Column | Description |
|--------|-------------|
| SafeName | Safe name |
| PlatformID | CyberArk platform (PolicyID) |
| AccountCount | Number of active accounts for this safe/platform combination |

### Variant B (safe only)

| Column | Description |
|--------|-------------|
| SafeName | Safe name |
| AccountCount | Total active accounts in this safe |
