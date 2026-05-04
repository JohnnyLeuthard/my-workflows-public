# Changelog — v14.2

**Version**: 14.2  
**Build**: 8.3.6  
**Release Date**: April 2026  
**Status**: Current production version

---

## Version Details

| Field | Value |
|-------|-------|
| **Version** | 14.2 |
| **Build** | 8.3.6 |
| **Release Date** | April 2026 |
| **Support Status** | Supported (current) |
| **Type** | Minor version upgrade from v12.2 |

---

## New Endpoints in v14.2 (vs v12.2)

### Authentication Methods Configuration (NEW endpoint group)
```
GET    /api/Configuration/AuthenticationMethods
GET    /api/Configuration/AuthenticationMethods/{id}
POST   /api/Configuration/AuthenticationMethods
PUT    /api/Configuration/AuthenticationMethods/{id}
DELETE /api/Configuration/AuthenticationMethods/{id}
```

**Purpose**: Manage vault authentication methods centrally. Configure MFA, certificate requirements, and authentication policies.  
**Breaking Changes**: None — additive only.

### Accounts: Secret Versions (NEW endpoint)
```
GET /api/Accounts/{id}/Secret/Versions
```

**Purpose**: Retrieve historical password versions for account. Supports compliance audit trails and version management.  
**Breaking Changes**: None — additive only.

### PTA Administration (NEW endpoint group)
```
GET    /api/PTA/Administration
PUT    /api/PTA/Administration/Properties
DELETE /api/PTA/Administration/Properties
POST   /api/PTA/Administration/GlobalCatalog
GET    /api/PTA/Administration/GlobalCatalog
```

**Purpose**: Centralized Privileged Threat Analytics configuration, scanner management, and threat catalog administration.  
**Breaking Changes**: None — additive only.

---

## Modified Endpoints

None documented. All v12.2 endpoints carry forward with identical signatures.

---

## Deprecated Endpoints

None. All v12.2 endpoints remain available.

---

## Removed Endpoints

None. Full backward compatibility with v12.2.

---

## Backward Compatibility

✅ **Full compatibility with v12.2** — All existing v12.2 clients work without modification.

---

## Migration Notes

**For v12.2 users upgrading to v14.2**:
- No code changes required
- New authentication methods available optionally
- Secret version history now accessible
- PTA administration now API-driven

---

## References

- Official Release Notes: https://docs.cyberark.com/pam-self-hosted/14.2/
- API Documentation: https://docs.cyberark.com/pam-self-hosted/14.2/en/content/webservices/
- Administrator Guide: https://docs.cyberark.com/pam-self-hosted/14.2/

---

**Last Updated**: 2026-05-03  
**Maintained By**: API Evaluation Workspace
