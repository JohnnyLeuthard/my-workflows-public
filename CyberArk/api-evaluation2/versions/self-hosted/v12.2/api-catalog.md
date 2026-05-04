# CyberArk PAM REST API v12.2 — Endpoint Catalog

**Version**: 12.2  
**Build**: 8.2.5 (Nov 2024)  
**Documentation Status**: ~40% complete  
**Source**: https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm

---

## API Overview

The CyberArk PAM REST API provides programmatic access to vault operations, including:
- Account management (create, read, update, delete)
- Safe management and permissions
- User and group management
- Platform configuration
- Session recording and monitoring
- Privileged account onboarding and discovery
- Request workflow management

## Endpoint Groups

Total endpoints: **~26** (documented coverage: 0/26)

### Core Resources

| Category | Endpoints | Status | Coverage |
|----------|-----------|--------|----------|
| **Authentication** | 1 | Planned | 0% |
| **Accounts** | 3 | Planned | 0% |
| **Account Actions** | 2 | Planned | 0% |
| **Account Groups** | 2 | Planned | 0% |
| **Safes** | 2 | Planned | 0% |
| **Users** | 2 | Planned | 0% |
| **Groups** | 1 | Planned | 0% |
| **Platforms** | 1 | Planned | 0% |
| **Requests** | 2 | Planned | 0% |
| **Sessions** | 2 | Planned | 0% |
| **General** | 1 | Planned | 0% |
| **System Health** | 1 | Planned | 0% |
| **Other** | 4 | Planned | 0% |

---

## Endpoint Summary

### Authentication

**Purpose**: Obtain API tokens for request authentication

- [Authentication.md](endpoints/Authentication.md) — API authentication methods and token generation

### Accounts

**Purpose**: Manage vault accounts (create, read, update, delete)

- [Accounts.md](endpoints/Accounts.md) — CRUD operations on vault accounts
- [AccountActions.md](endpoints/AccountActions.md) — Retrieve and verify account credentials
- [AccountGroups.md](endpoints/AccountGroups.md) — Group accounts by logical categories

### Safes

**Purpose**: Manage safes (vaults containing accounts)

- [Safes.md](endpoints/Safes.md) — Create and manage safes
- [Safes.md#members](endpoints/Safes.md) — Manage safe membership and permissions

### Users & Groups

**Purpose**: Manage vault users and directory groups

- [Users.md](endpoints/Users.md) — Manage vault users and API consumers
- [Groups.md](endpoints/Groups.md) — Manage vault groups and memberships

### Platforms

**Purpose**: Define and manage target system platforms

- [Platforms.md](endpoints/Platforms.md) — Manage platform definitions (Unix, Windows, etc.)

### Requests & Workflow

**Purpose**: Manage access requests and workflow approvals

- [Requests.md](endpoints/Requests.md) — Request account access, view approval status

### Session Management

**Purpose**: Monitor and control user sessions

- [MonitorSessions.md](endpoints/MonitorSessions.md) — Monitor active sessions
- [SessionManagement.md](endpoints/SessionManagement.md) — Disconnect sessions, view session details

### Advanced Features

**Purpose**: Specialized API capabilities

- [LinkedAccounts.md](endpoints/LinkedAccounts.md) — Link related accounts across platforms
- [DiscoveredAccounts.md](endpoints/DiscoveredAccounts.md) — Manage accounts discovered by PTA
- [LDAPIntegration.md](endpoints/LDAPIntegration.md) — Configure LDAP directory integration
- [SSHKeys.md](endpoints/SSHKeys.md) — Manage SSH keys for accounts
- [BulkUpload.md](endpoints/BulkUpload.md) — Import accounts in bulk
- [OPMCommands.md](endpoints/OPMCommands.md) — One-time password and command execution
- [OnboardingRules.md](endpoints/OnboardingRules.md) — Define automated onboarding rules

### Operational

**Purpose**: Monitoring and troubleshooting

- [SystemHealth.md](endpoints/SystemHealth.md) — Check API and vault system health
- [General.md](endpoints/General.md) — General information and metadata endpoints
- [PTAInstallation.md](endpoints/PTAInstallation.md) — PTA scanner configuration and status
- [Security.md](endpoints/Security.md) — Security configuration and SSL/TLS settings
- [Server.md](endpoints/Server.md) — Server information and configuration

### Examples & Usage

**Purpose**: Common usage patterns and recipes

- [UsageExamples.md](endpoints/UsageExamples.md) — Code examples and recipes for common tasks

---

## Quick Links

### By HTTP Method

- **GET**: Most read operations (list, retrieve, search)
- **POST**: Create operations and state-changing actions
- **PUT**: Update operations
- **DELETE**: Remove operations

### By Authentication

- **Certificate-based**: Recommended for service-to-service APIs
- **Token-based**: Recommended for interactive or user-initiated calls
- **Windows Integrated**: Supported in on-premises deployments

### By Use Case

**Automated Onboarding**
- POST /api/Accounts (create account)
- POST /api/SafeMembers (grant access)
- POST /api/Platforms (create platform if needed)

**Credential Retrieval**
- GET /api/Accounts (list)
- GET /api/Accounts/{id}/credentials (retrieve secret)

**Compliance & Audit**
- GET /api/Accounts (search by metadata)
- GET /api/Sessions (monitor access)
- GET /api/SystemHealth (verify operational status)

---

## API Versioning

### URL Format

```
https://<vault-server>/api/[resource]
```

### Headers

```
Content-Type: application/json
Authorization: Bearer <token> or CyberArk <session-token>
X-CERT-THUMBPRINT: [cert-thumbprint] (if using certificate auth)
```

### Response Format

```json
{
  "status": "success|error",
  "data": { ... },
  "error": "error message if status = error"
}
```

### Pagination

List endpoints support pagination via query parameters:
- `limit`: Max results per page (default: 25, max: 100)
- `offset`: Pagination offset (default: 0)

Example: `/api/Accounts?limit=50&offset=0`

---

## Error Handling

### Common Error Codes

| Code | Meaning | Common Causes |
|------|---------|--------------|
| 400 | Bad Request | Invalid parameters, malformed JSON |
| 401 | Unauthorized | Missing or expired token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource, state conflict |
| 500 | Server Error | Vault internal error |

### Error Response Format

```json
{
  "status": "error",
  "error": "Description of what went wrong"
}
```

---

## Rate Limiting

No documented rate limits. Follow REST best practices:
- Batch operations where possible
- Implement exponential backoff on errors
- Cache read operations when appropriate

---

## Security Considerations

- **Always use HTTPS** — Never send credentials over unencrypted connections
- **Rotate tokens** — Obtain new tokens periodically; don't reuse indefinitely
- **Minimize secret exposure** — Avoid logging or storing credentials in plaintext
- **Audit access** — Review vault audit logs for all API operations
- **Principle of least privilege** — Grant minimum permissions required for each integration

---

## Documentation Status

| Endpoint | Status | Completeness |
|----------|--------|--------------|
| [AccountActions.md](endpoints/AccountActions.md) | ⏳ Pending | 0% |
| [AccountGroups.md](endpoints/AccountGroups.md) | ⏳ Pending | 0% |
| [Accounts.md](endpoints/Accounts.md) | ⏳ Pending | 0% |
| [Applications.md](endpoints/Applications.md) | ⏳ Pending | 0% |
| [Authentication.md](endpoints/Authentication.md) | ⏳ Pending | 0% |
| [BulkUpload.md](endpoints/BulkUpload.md) | ⏳ Pending | 0% |
| [DiscoveredAccounts.md](endpoints/DiscoveredAccounts.md) | ⏳ Pending | 0% |
| [General.md](endpoints/General.md) | ⏳ Pending | 0% |
| [Groups.md](endpoints/Groups.md) | ⏳ Pending | 0% |
| [LDAPIntegration.md](endpoints/LDAPIntegration.md) | ⏳ Pending | 0% |
| [LinkedAccounts.md](endpoints/LinkedAccounts.md) | ⏳ Pending | 0% |
| [MonitorSessions.md](endpoints/MonitorSessions.md) | ⏳ Pending | 0% |
| [OnboardingRules.md](endpoints/OnboardingRules.md) | ⏳ Pending | 0% |
| [OPMCommands.md](endpoints/OPMCommands.md) | ⏳ Pending | 0% |
| [Platforms.md](endpoints/Platforms.md) | ⏳ Pending | 0% |
| [PTAInstallation.md](endpoints/PTAInstallation.md) | ⏳ Pending | 0% |
| [Requests.md](endpoints/Requests.md) | ⏳ Pending | 0% |
| [Safes.md](endpoints/Safes.md) | ⏳ Pending | 0% |
| [Security.md](endpoints/Security.md) | ⏳ Pending | 0% |
| [Server.md](endpoints/Server.md) | ⏳ Pending | 0% |
| [SessionManagement.md](endpoints/SessionManagement.md) | ⏳ Pending | 0% |
| [SSHKeys.md](endpoints/SSHKeys.md) | ⏳ Pending | 0% |
| [SystemHealth.md](endpoints/SystemHealth.md) | ⏳ Pending | 0% |
| [UsageExamples.md](endpoints/UsageExamples.md) | ⏳ Pending | 0% |
| [Users.md](endpoints/Users.md) | ⏳ Pending | 0% |

---

**Source**: https://docs.cyberark.com/pam-self-hosted/12.2/  
**Last Updated**: [To be updated after documentation fetch]
