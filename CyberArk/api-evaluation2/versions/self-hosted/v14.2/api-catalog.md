# CyberArk PAM REST API v14.2 — Endpoint Catalog

**Version**: 14.2  
**Build**: 8.3.6 (Apr 2026)  
**Documentation Status**: ~70% complete  
**Source**: https://docs.cyberark.com/pam-self-hosted/14.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm

---

## API Overview

The CyberArk PAM REST API v14.2 builds on v12.2 with enhanced authentication management, secret versioning, and PTA administration capabilities.

## Endpoint Groups

Total endpoints: **~36** (25 from v12.2 + 11 new in v14.2)

### Core Resources (v12.2 baseline)

| Category | Endpoints | Status |
|----------|-----------|--------|
| **Authentication** | 1 | Complete |
| **Accounts** | 3 | Complete |
| **Account Actions** | 2 | Complete |
| **Account Groups** | 2 | Complete |
| **Safes** | 2 | Complete |
| **Users** | 2 | Complete |
| **Groups** | 1 | Complete |
| **Platforms** | 1 | Complete |
| **Requests** | 2 | Complete |
| **Sessions** | 2 | Complete |
| **General** | 1 | Complete |
| **System Health** | 1 | Complete |
| **Other** | 4 | Complete |

### New in v14.2

| Category | Endpoints | Status |
|----------|-----------|--------|
| **Authentication Methods Config** | 5 | Complete |
| **Accounts: Secret Versions** | 1 | Complete |
| **PTA Administration** | 5 | Complete |

---

## New Endpoints in v14.2

### Authentication Methods Configuration (NEW)

- GET /api/Configuration/AuthenticationMethods
- GET /api/Configuration/AuthenticationMethods/{id}
- POST /api/Configuration/AuthenticationMethods
- PUT /api/Configuration/AuthenticationMethods/{id}
- DELETE /api/Configuration/AuthenticationMethods/{id}

### Accounts: Secret Versions (NEW)

- GET /api/Accounts/{id}/Secret/Versions

### PTA Administration (NEW)

- GET /api/PTA/Administration
- PUT /api/PTA/Administration/Properties
- DELETE /api/PTA/Administration/Properties
- POST /api/PTA/Administration/GlobalCatalog
- GET /api/PTA/Administration/GlobalCatalog

---

## Changes from v12.2

- ✨ Centralized authentication method configuration
- ✨ Account secret/password version history retrieval
- ✨ Enhanced PTA scanner administration and management
- ✅ All v12.2 endpoints remain compatible

---

**Source**: https://docs.cyberark.com/pam-self-hosted/14.2/  
**Last Updated**: 2026-05-03
