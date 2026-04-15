# Request Audit

> **Category**: Operations
> **Tables**: dbo.CARequests, dbo.CAConfirmations
> **Requires**: —
> **Note**: `CARStatus` is an integer code. Known values: 1 = Pending, 2 = Active, 4 = Expired, 8 = Used, 16 = Rejected, 32 = Deleted. Confirm codes in your environment via `dbo.CATextCodes` before filtering on status. `CACAction` in CAConfirmations is also an integer — treat as informational unless you have your environment's lookup.

---

## Description

Audit access request history for vault safes — who requested access, which accounts were targeted, whether requests were confirmed or rejected, and how long requests sat open. Useful for SOX/audit evidence, dual-control configuration reviews, and identifying accounts that are repeatedly requested (suggesting they may benefit from automation or standing access).

Variant A returns full request detail with confirmer information. Variant B aggregates by safe for a traffic summary.

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Lookback window | 90 days | `DATEADD(day, -90, ...)` on `CARCreationDate` | How far back to pull request history |
| Safe prefix filter | *(none)* | Add `AND r.CARSafeName LIKE '...'` | Narrow to specific safe groups |
| Status filter | All statuses | Add `AND r.CARStatus IN (...)` | Filter to specific status codes (see header note) |

---

## SQL — Variant A (Full Request Detail)

```sql
SELECT
    r.CARRequestID                  AS RequestID,
    r.CARSafeName                   AS SafeName,
    r.CARFileName                   AS AccountName,
    r.CARUserName                   AS Requester,
    r.CARReason                     AS RequestReason,
    r.CARStatus                     AS StatusCode,  -- see header for known values
    r.CARAccessType                 AS AccessTypeCode,
    r.CARConfirmationsCount         AS ConfirmationsRequired,
    r.CARConfirmationsLeft          AS ConfirmationsRemaining,
    r.CARRejectionsCount            AS RejectionCount,
    r.CARCreationDate               AS RequestDate,
    r.CARExpirationDate             AS ExpirationDate,
    r.CARLastUsedDate               AS LastUsedDate,
    DATEDIFF(hour,
        r.CARCreationDate,
        COALESCE(r.CARLastUsedDate, GETDATE())
    )                               AS RequestAgeHours,
    c.CACUserName                   AS ConfirmerUserName,
    c.CACGroupName                  AS ConfirmerGroupName,
    c.CACAction                     AS ConfirmerActionCode, -- integer; see CATextCodes
    c.CACReason                     AS ConfirmationReason,
    c.CACActionDate                 AS ConfirmationDate
FROM dbo.CARequests r
LEFT JOIN dbo.CAConfirmations c
    ON c.CACRequestID = r.CARRequestID
WHERE
    -- CUSTOMIZE: change 90 to your lookback window
    r.CARCreationDate >= DATEADD(day, -90, CAST(GETDATE() AS date))
    -- CUSTOMIZE: add safe prefix filter
    -- AND r.CARSafeName LIKE 'SA-%'
    -- CUSTOMIZE: add status filter (e.g., pending only: AND r.CARStatus = 1)
    -- AND r.CARStatus IN (1, 2)
    -- System safe exclusions from references/system_safe_exclusions.md -- keep in sync
    -- Vault Infrastructure
    AND r.CARSafeName NOT IN (
        'System', 'VaultInternal', 'Notification', 'SharedAuth_Internal'
    )
    -- PVWA
    AND r.CARSafeName NOT IN (
        'PVWAConfig', 'PVWAReports', 'PVWATicketingSystem',
        'PVWATaskDefinitions', 'PVWAPublicData',
        'PVWAUserPrefs', 'PVWAPrivateUserPrefs'
    )
    AND r.CARSafeName NOT LIKE 'PVWAUserPrefs-%'
    AND r.CARSafeName NOT LIKE 'PVWAPrivateUserPrefs-%'
    -- CPM
    AND r.CARSafeName NOT LIKE 'PasswordManager%'
    AND r.CARSafeName NOT LIKE 'CPM_%_workspace'
    AND r.CARSafeName NOT LIKE 'CPM_%_Logs'
    AND r.CARSafeName NOT LIKE 'CPM_%_info'
    AND r.CARSafeName NOT LIKE 'CPM_%_info-rest'
    -- PSM
    AND r.CARSafeName NOT IN (
        'PSM', 'PSM-PA-', 'PSMSessions', 'PSMLiveSessions',
        'PSMNotifications', 'PSMUniversalConnectors',
        'PSMUnmanagedSessionAccounts', 'PSMPADBridgeConf', 'PSMPADBridgeCustom'
    )
    AND r.CARSafeName NOT LIKE 'PSMRecordings%'
    -- AAM
    AND r.CARSafeName NOT IN ('AppProviderConf', 'AppProviderCacheSafe')
    -- Discovery
    AND r.CARSafeName NOT IN ('AccountsFeedADAccounts', 'AccountsFeedDiscovery')
    -- Conjur
    AND r.CARSafeName NOT IN ('ConjurSync')
ORDER BY
    r.CARCreationDate DESC,
    r.CARSafeName ASC;
```

---

## SQL — Variant B (Per-Safe Summary)

```sql
SELECT
    r.CARSafeName                   AS SafeName,
    COUNT(DISTINCT r.CARRequestID)  AS TotalRequests,
    SUM(CASE WHEN r.CARStatus = 16 THEN 1 ELSE 0 END)
                                    AS RejectedCount,
    SUM(CASE WHEN r.CARStatus = 1  THEN 1 ELSE 0 END)
                                    AS PendingCount,
    AVG(DATEDIFF(hour,
        r.CARCreationDate,
        COALESCE(r.CARLastUsedDate, GETDATE())
    ))                              AS AvgRequestAgeHours,
    MAX(r.CARCreationDate)          AS LastRequestDate
FROM dbo.CARequests r
WHERE
    -- CUSTOMIZE: change 90 to your lookback window
    r.CARCreationDate >= DATEADD(day, -90, CAST(GETDATE() AS date))
    -- CUSTOMIZE: add safe prefix filter
    -- AND r.CARSafeName LIKE 'SA-%'
    -- System safe exclusions from references/system_safe_exclusions.md -- keep in sync
    -- Vault Infrastructure
    AND r.CARSafeName NOT IN (
        'System', 'VaultInternal', 'Notification', 'SharedAuth_Internal'
    )
    -- PVWA
    AND r.CARSafeName NOT IN (
        'PVWAConfig', 'PVWAReports', 'PVWATicketingSystem',
        'PVWATaskDefinitions', 'PVWAPublicData',
        'PVWAUserPrefs', 'PVWAPrivateUserPrefs'
    )
    AND r.CARSafeName NOT LIKE 'PVWAUserPrefs-%'
    AND r.CARSafeName NOT LIKE 'PVWAPrivateUserPrefs-%'
    -- CPM
    AND r.CARSafeName NOT LIKE 'PasswordManager%'
    AND r.CARSafeName NOT LIKE 'CPM_%_workspace'
    AND r.CARSafeName NOT LIKE 'CPM_%_Logs'
    AND r.CARSafeName NOT LIKE 'CPM_%_info'
    AND r.CARSafeName NOT LIKE 'CPM_%_info-rest'
    -- PSM
    AND r.CARSafeName NOT IN (
        'PSM', 'PSM-PA-', 'PSMSessions', 'PSMLiveSessions',
        'PSMNotifications', 'PSMUniversalConnectors',
        'PSMUnmanagedSessionAccounts', 'PSMPADBridgeConf', 'PSMPADBridgeCustom'
    )
    AND r.CARSafeName NOT LIKE 'PSMRecordings%'
    -- AAM
    AND r.CARSafeName NOT IN ('AppProviderConf', 'AppProviderCacheSafe')
    -- Discovery
    AND r.CARSafeName NOT IN ('AccountsFeedADAccounts', 'AccountsFeedDiscovery')
    -- Conjur
    AND r.CARSafeName NOT IN ('ConjurSync')
GROUP BY
    r.CARSafeName
ORDER BY
    TotalRequests DESC,
    r.CARSafeName ASC;
```

---

## Output Columns

### Variant A

| Column | Description |
|--------|-------------|
| RequestID | Unique request identifier |
| SafeName | Safe the request targets |
| AccountName | Account object the request targets |
| Requester | Vault username who submitted the request |
| RequestReason | Justification provided by the requester |
| StatusCode | Integer status code — see header for known values |
| AccessTypeCode | Integer access type code |
| ConfirmationsRequired | Total number of confirmations required by safe policy |
| ConfirmationsRemaining | Confirmations still pending |
| RejectionCount | Number of rejections received |
| RequestDate | When the request was submitted |
| ExpirationDate | When the request expires (if no action taken) |
| LastUsedDate | When the request was last used to check out the account |
| RequestAgeHours | Hours from request creation to last use (or now if still open) |
| ConfirmerUserName | Vault username of the confirmer (NULL if no confirmation yet) |
| ConfirmerGroupName | Group associated with the confirmer |
| ConfirmerActionCode | Integer action code (confirm / reject) |
| ConfirmationReason | Reason given by the confirmer |
| ConfirmationDate | When the confirmation or rejection occurred |

### Variant B

| Column | Description |
|--------|-------------|
| SafeName | Safe being summarized |
| TotalRequests | Total distinct requests in the lookback window |
| RejectedCount | Number of requests rejected (status = 16) |
| PendingCount | Number of requests still pending (status = 1) |
| AvgRequestAgeHours | Average hours from creation to last use across all requests |
| LastRequestDate | Most recent request date for this safe |
