# All Changes Across Versions

A comprehensive record of API changes, additions, and deprecations across all tracked CyberArk versions.

## Change Categories

- **Added**: New endpoints or parameters
- **Modified**: Existing endpoints with changed behavior, schema, or requirements
- **Deprecated**: Endpoints marked for removal in future versions
- **Removed**: Endpoints no longer available

## v12.2 → v14.2.1

### Added Endpoints

#### Authentication Methods Configuration (NEW endpoint group)
```
GET    /api/Configuration/AuthenticationMethods
GET    /api/Configuration/AuthenticationMethods/{id}
POST   /api/Configuration/AuthenticationMethods
PUT    /api/Configuration/AuthenticationMethods/{id}
DELETE /api/Configuration/AuthenticationMethods/{id}
```

**Impact**: Allows centralized management of authentication methods. Required for multi-auth deployments.  
**Breaking**: No — additive only.

#### Accounts: Secret Versions
```
GET /api/Accounts/{id}/Secret/Versions
```

**Impact**: Retrieve historical secret versions for an account. Supports audit trails.  
**Breaking**: No — additive only.

#### PTA Administration (NEW endpoint group)
```
GET    /api/PTA/Administration
PUT    /api/PTA/Administration/Properties
DELETE /api/PTA/Administration/Properties
POST   /api/PTA/Administration/GlobalCatalog
GET    /api/PTA/Administration/GlobalCatalog
```

**Impact**: Centralized PTA configuration and threat catalog management.  
**Breaking**: No — additive only.

### Modified Endpoints

(To be filled in as documentation is reviewed)

### Deprecated Endpoints

(None documented so far)

### Removed Endpoints

(None documented so far)

## v14.2.1 → v14.4

### Added Endpoints

#### Authentication: Advanced Methods
```
GET /api/Configuration/AuthenticationMethods
```

**Note**: May be duplicate or enhancement of v14.2.1 endpoint. Requires review.

#### Accounts: Advanced Search Properties
```
GET /api/Accounts/AdvancedSearchProperties
```

**Impact**: Query supported search properties for advanced account filtering.  
**Breaking**: No — additive only.

### Modified Endpoints

(To be filled in as documentation is reviewed)

### Deprecated Endpoints

(None documented so far)

### Removed Endpoints

(None documented so far)

## Summary by Version

| Version | Total Endpoints | New in This Version | Breaking Changes | Status |
|---------|-----------------|-------------------|------------------|--------|
| 12.2    | ~26             | — (baseline)      | —                | Reference |
| 14.2.1  | ~31             | 8 (estimated)     | 0 (none found)   | Planned |
| 14.4    | ~33             | 2 (confirmed)     | 0 (none found)   | Planned |

## How to Use This File

1. **For migration planning**: Review "Breaking Changes" to assess upgrade impact
2. **For feature mapping**: Cross-reference "Added" sections against deployment requirements
3. **For API client updates**: Check "Modified" sections for schema or behavior changes
4. **For deprecation planning**: Monitor "Deprecated" for endpoints approaching end-of-life

## Notes on Completeness

- v12.2 baseline is ~40% documented — many endpoints require review for accuracy
- v14.2.1 comparison assumes v12.2 as baseline; gaps may exist if v14.2.1 added endpoints not in v12.2
- v14.4 is minimal — only confirmed changes listed
- "Breaking Changes" column reflects findings so far; not exhaustive until full comparison is done

---

**Last Updated**: (Initial setup)  
**Maintained by**: API Evaluation Workspace
