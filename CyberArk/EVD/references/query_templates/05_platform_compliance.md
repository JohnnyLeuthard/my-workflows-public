# Platform Compliance

> **Category**: Compliance
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: naming_standards.md (for expected platform mappings)

---

## Description

Find accounts where the assigned PolicyID does not match the expected platforms for the safe's technology group. Useful for identifying misconfigured accounts, platform migration candidates, and pre-audit cleanup.

This template requires `naming_standards.md` to define the expected safe-to-platform mapping. Without it, you'll need to manually specify which platforms are valid for which safe prefixes.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Safe prefix | `'SA-%'` | `f.CAFSafeName LIKE '...'` | Target safe group to check |
| Expected platforms | *(must customize)* | `NOT IN (...)` in HAVING | List valid PolicyID values for this safe group |

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
             THEN op.CAOPObjectPropertyValue END) AS PlatformID
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
    -- CUSTOMIZE: target safe prefix
    AND f.CAFSafeName LIKE 'SA-%'
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
-- CUSTOMIZE: list the valid platforms for your target safe group
-- Replace the platform list below with values from naming_standards.md
HAVING MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
                THEN op.CAOPObjectPropertyValue END)
       NOT IN ('LinuxSSH', 'LinuxSSHKeys')
    -- Also flag accounts with no platform assigned
    OR MAX(CASE WHEN op.CAOPObjectPropertyName = 'PolicyID'
                THEN op.CAOPObjectPropertyValue END) IS NULL
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
| PlatformID | Assigned platform — will be either mismatched or NULL for flagged accounts |
