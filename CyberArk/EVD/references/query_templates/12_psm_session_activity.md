# PSM Session Activity

> **Category**: Operations
> **Tables**: dbo.CAFiles, dbo.CAObjectProperties
> **Requires**: —
> **Note**: PSM session data is stored in `CAObjectProperties` (EAV), not a dedicated session table. `PSMStartTime` and `PSMEndTime` format varies by environment — verify whether they are stored as Unix epoch integers or human-readable strings before date-filtering on those fields. See `../datetime_handling.md` for epoch conversion.

---

## Description

Find accounts that have had PSM sessions and surface those with missing or failed recordings. Useful for confirming that privileged sessions are being recorded as expected, identifying recording gaps for compliance purposes, and reviewing which connection components are in use.

Accounts with no PSM session data are excluded by the `HAVING` clause — only accounts that have actually been connected through PSM appear in results.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Safe prefix filter | *(none)* | Add `AND f.CAFSafeName LIKE '...'` | Narrow to specific safe groups |
| Missing recordings only | No | Uncomment the `HAVING` addition at the bottom | Return only accounts with `ActualRecordings` null or zero |
| Protocol filter | All | Add `AND ... PSMProtocol ... = 'RDP'` to the HAVING clause | Narrow to a specific session protocol |

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
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'ConnectionComponentID'
             THEN op.CAOPObjectPropertyValue END) AS ConnectionComponent,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PSMRemoteMachine'
             THEN op.CAOPObjectPropertyValue END) AS PSMRemoteMachine,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PSMProtocol'
             THEN op.CAOPObjectPropertyValue END) AS PSMProtocol,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PSMStatus'
             THEN op.CAOPObjectPropertyValue END) AS PSMStatus,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PSMStartTime'
             THEN op.CAOPObjectPropertyValue END) AS PSMStartTime,  -- verify format; may need epoch conversion
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'PSMEndTime'
             THEN op.CAOPObjectPropertyValue END) AS PSMEndTime,    -- verify format; may need epoch conversion
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'ReportDuration'
             THEN op.CAOPObjectPropertyValue END) AS SessionDuration,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'ActualRecordings'
             THEN op.CAOPObjectPropertyValue END) AS ActualRecordings,
    MAX(CASE WHEN op.CAOPObjectPropertyName = 'RecordingUploadError'
             THEN op.CAOPObjectPropertyValue END) AS RecordingUploadError,
    CASE
        WHEN MAX(CASE WHEN op.CAOPObjectPropertyName = 'ActualRecordings'
                      THEN op.CAOPObjectPropertyValue END) IS NULL
          OR MAX(CASE WHEN op.CAOPObjectPropertyName = 'ActualRecordings'
                      THEN op.CAOPObjectPropertyValue END) = '0'
        THEN 'Yes'
        ELSE 'No'
    END                             AS MissingRecording
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
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
    f.CAFSafeName, f.CAFFileName
-- Only return accounts that have had at least one PSM session
HAVING MAX(CASE WHEN op.CAOPObjectPropertyName = 'ConnectionComponentID'
                THEN op.CAOPObjectPropertyValue END) IS NOT NULL
-- CUSTOMIZE: uncomment to return ONLY accounts with missing or failed recordings
-- AND (
--     MAX(CASE WHEN op.CAOPObjectPropertyName = 'ActualRecordings'
--              THEN op.CAOPObjectPropertyValue END) IS NULL
--     OR MAX(CASE WHEN op.CAOPObjectPropertyName = 'ActualRecordings'
--              THEN op.CAOPObjectPropertyValue END) = '0'
-- )
ORDER BY
    MissingRecording DESC,
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
| PlatformID | Assigned CyberArk platform (PolicyID) |
| ConnectionComponent | PSM connection component ID used |
| PSMRemoteMachine | Recorded remote machine name for the session |
| PSMProtocol | Session protocol (e.g., RDP, SSH) |
| PSMStatus | Session status value from PSM |
| PSMStartTime | Session start time — verify format against your environment |
| PSMEndTime | Session end time — verify format against your environment |
| SessionDuration | Reported session duration |
| ActualRecordings | Number of recordings captured (NULL or `'0'` = no recording) |
| RecordingUploadError | Error message if recording upload failed |
| MissingRecording | `'Yes'` if ActualRecordings is null or zero, `'No'` otherwise |
