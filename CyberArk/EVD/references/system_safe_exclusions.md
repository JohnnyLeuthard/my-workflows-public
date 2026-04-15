# System Safe Exclusions — EVD Reference

> On-demand reference. Load when writing any EVD query that touches CAFiles or CASafes.
> Do **not** pre-load — open only when safe filtering is relevant.

---

## Default Behavior

**Exclude all system safes** listed below unless the user explicitly requests otherwise.

CyberArk vaults contain dozens of internal/infrastructure safes that are not relevant to account inventory, compliance, or operational queries. Including them produces noise and inflated counts.

---

## When to Load / Skip

| Scenario | Action |
|----------|--------|
| Query filters on safes (most queries) | Load this file and apply exclusions |
| User says "include system safes" or "all safes" | Skip exclusions entirely |
| User asks about a specific system safe by name | Include only that safe, exclude the rest |

---

## Alias Guide

Replace `{safe}` in the SQL template below with the appropriate column:

| Table | Column |
|-------|--------|
| dbo.CAFiles | `f.CAFSafeName` |
| dbo.CASafes | `s.CASSafeName` |

---

## Exclusion Catalog

### Vault Infrastructure

| Name / Pattern | Match Type | Notes |
|---------------|------------|-------|
| System | Exact | Vault system safe |
| VaultInternal | Exact | Internal config / metadata |
| Notification | Exact | Notification engine storage |
| SharedAuth_Internal | Exact | Shared auth internal data |

### PVWA (Password Vault Web Access)

| Name / Pattern | Match Type | Notes |
|---------------|------------|-------|
| PVWAConfig | Exact | PVWA configuration |
| PVWAReports | Exact | Scheduled reports |
| PVWATicketingSystem | Exact | Ticketing integration |
| PVWATaskDefinitions | Exact | Workflow definitions |
| PVWAPublicData | Exact | Public shared data |
| PVWAUserPrefs | Exact | User preferences |
| PVWAPrivateUserPrefs | Exact | Private preferences |
| PVWAUserPrefs-% | LIKE | REST partitions |
| PVWAPrivateUserPrefs-% | LIKE | REST partitions |

### CPM (Central Policy Manager)

| Name / Pattern | Match Type | Notes |
|---------------|------------|-------|
| PasswordManager% | LIKE | CPM operational safes |
| CPM_%_workspace | LIKE | Temporary workspace |
| CPM_%_Logs | LIKE | Log backup safes |
| CPM_%_info | LIKE | Info / state safes |
| CPM_%_info-rest | LIKE | REST partitions |

### PSM (Privileged Session Manager)

| Name / Pattern | Match Type | Notes |
|---------------|------------|-------|
| PSM | Exact | Core config |
| PSM-PA- | Exact | PSM PA safe |
| PSMSessions | Exact | Session metadata |
| PSMLiveSessions | Exact | Active sessions |
| PSMNotifications | Exact | Notification queue |
| PSMUniversalConnectors | Exact | Connector definitions |
| PSMUnmanagedSessionAccounts | Exact | Unmanaged session records |
| PSMPADBridgeConf | Exact | Bridge config |
| PSMPADBridgeCustom | Exact | Custom bridge config |
| PSMRecordings% | LIKE | Recording storage |

### AAM (Application Access Manager)

| Name / Pattern | Match Type | Notes |
|---------------|------------|-------|
| AppProviderConf | Exact | CP config files |
| AppProviderCacheSafe | Exact | Credential cache |

### Discovery / Account Feed

| Name / Pattern | Match Type | Notes |
|---------------|------------|-------|
| AccountsFeedADAccounts | Exact | AD discovery feed |
| AccountsFeedDiscovery | Exact | General discovery |

### Conjur Sync

| Name / Pattern | Match Type | Notes |
|---------------|------------|-------|
| ConjurSync | Exact | Conjur sync safe |

---

## SQL Template

Copy this WHERE clause fragment into your query. Replace `{safe}` with the appropriate alias from the table above.

```sql
-- System safe exclusions (default behavior)
-- Vault Infrastructure
AND {safe} NOT IN (
    'System',
    'VaultInternal',
    'Notification',
    'SharedAuth_Internal'
)

-- PVWA
AND {safe} NOT IN (
    'PVWAConfig',
    'PVWAReports',
    'PVWATicketingSystem',
    'PVWATaskDefinitions',
    'PVWAPublicData',
    'PVWAUserPrefs',
    'PVWAPrivateUserPrefs'
)
AND {safe} NOT LIKE 'PVWAUserPrefs-%'
AND {safe} NOT LIKE 'PVWAPrivateUserPrefs-%'

-- CPM
AND {safe} NOT LIKE 'PasswordManager%'
AND {safe} NOT LIKE 'CPM_%_workspace'
AND {safe} NOT LIKE 'CPM_%_Logs'
AND {safe} NOT LIKE 'CPM_%_info'
AND {safe} NOT LIKE 'CPM_%_info-rest'

-- PSM
AND {safe} NOT IN (
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
AND {safe} NOT LIKE 'PSMRecordings%'

-- AAM
AND {safe} NOT IN (
    'AppProviderConf',
    'AppProviderCacheSafe'
)

-- Discovery
AND {safe} NOT IN (
    'AccountsFeedADAccounts',
    'AccountsFeedDiscovery'
)

-- Conjur
AND {safe} NOT IN (
    'ConjurSync'
)
```
