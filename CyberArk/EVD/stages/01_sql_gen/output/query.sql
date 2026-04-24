-- Query: Privileged IDs Disabled by CPM
-- Description: Returns all managed credential accounts (CAFType = 2) where the
--              CPMDisabled property is set, indicating CPM has been disabled for
--              the account. Any non-empty value in CPMDisabled means disabled.
-- Template:    02_cpm_health.md (Option A — CPM disabled only)
-- Scope note:  To narrow to specific privileged safe groups, add a safe name
--              filter after the system safe exclusions (e.g., AND f.CAFSafeName LIKE 'PA-%').

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
    -- System safe exclusions (default behavior)
    -- Vault Infrastructure
    AND f.CAFSafeName NOT IN (
        'System',
        'VaultInternal',
        'Notification',
        'SharedAuth_Internal'
    )
    -- PVWA
    AND f.CAFSafeName NOT IN (
        'PVWAConfig',
        'PVWAReports',
        'PVWATicketingSystem',
        'PVWATaskDefinitions',
        'PVWAPublicData',
        'PVWAUserPrefs',
        'PVWAPrivateUserPrefs'
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
        'PSM',
        'PSM-PA-',
        'PSMSessions',
        'PSMLiveSessions',
        'PSMNotifications',
        'PSMUniversalConnectors',
        'PSMUnmanagedSessionAccounts',
        'PSMPADBridgeConf',
        'PSMPADBridgeCustom'
    )
    AND f.CAFSafeName NOT LIKE 'PSMRecordings%'
    -- AAM
    AND f.CAFSafeName NOT IN (
        'AppProviderConf',
        'AppProviderCacheSafe'
    )
    -- Discovery
    AND f.CAFSafeName NOT IN (
        'AccountsFeedADAccounts',
        'AccountsFeedDiscovery'
    )
    -- Conjur
    AND f.CAFSafeName NOT IN (
        'ConjurSync'
    )
GROUP BY
    f.CAFSafeName,
    f.CAFFileName
-- CPM disabled: any non-empty value in CPMDisabled means the account is disabled.
-- Do not match a specific string — per eva_query_patterns.md boolean property pattern.
HAVING MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
                THEN op.CAOPObjectPropertyValue END) IS NOT NULL
   AND MAX(CASE WHEN op.CAOPObjectPropertyName = 'CPMDisabled'
                THEN op.CAOPObjectPropertyValue END) <> ''
ORDER BY
    f.CAFSafeName ASC,
    f.CAFFileName ASC;
