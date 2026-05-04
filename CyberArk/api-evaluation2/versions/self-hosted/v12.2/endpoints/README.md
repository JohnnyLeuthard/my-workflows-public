# v12.2 Endpoints

This folder contains endpoint-by-endpoint documentation for CyberArk PAM REST API v12.2.

## File List

Each file follows the `endpoint-template.md` format with complete details on:
- HTTP methods and paths
- Authentication requirements
- Parameters (URL, query, headers)
- Request/response schemas
- Error codes
- Related endpoints

### Endpoints by Category

#### Authentication
- [Authentication.md](Authentication.md) — API token generation and validation

#### Accounts (Core)
- [Accounts.md](Accounts.md) — Create, read, update, delete vault accounts
- [AccountActions.md](AccountActions.md) — Retrieve and verify credentials
- [AccountGroups.md](AccountGroups.md) — Group accounts for organizational purposes

#### Safes
- [Safes.md](Safes.md) — Create and manage vaults (safes)
- Safes membership — See Safes.md for member management endpoints

#### Users & Groups
- [Users.md](Users.md) — Manage vault users and API consumers
- [Groups.md](Groups.md) — Manage vault groups and memberships

#### Platforms
- [Platforms.md](Platforms.md) — Define and manage target system platforms

#### Requests
- [Requests.md](Requests.md) — Request account access and manage approval workflow

#### Sessions
- [MonitorSessions.md](MonitorSessions.md) — Monitor and analyze active sessions
- [SessionManagement.md](SessionManagement.md) — Control sessions and retrieve session details

#### Advanced Features
- [LinkedAccounts.md](LinkedAccounts.md) — Link related accounts across systems
- [DiscoveredAccounts.md](DiscoveredAccounts.md) — Manage discovered account inventory
- [LDAPIntegration.md](LDAPIntegration.md) — Configure LDAP/Active Directory integration
- [SSHKeys.md](SSHKeys.md) — Manage SSH public keys for accounts
- [BulkUpload.md](BulkUpload.md) — Bulk import accounts from CSV
- [OPMCommands.md](OPMCommands.md) — Execute one-time password and command operations
- [OnboardingRules.md](OnboardingRules.md) — Define automated account discovery and onboarding

#### Operational
- [SystemHealth.md](SystemHealth.md) — Vault and API health status
- [General.md](General.md) — General metadata and information endpoints
- [PTAInstallation.md](PTAInstallation.md) — PTA (Privileged Threat Analytics) configuration
- [Security.md](Security.md) — Security settings, SSL/TLS configuration
- [Server.md](Server.md) — Server information and diagnostics

#### Examples
- [UsageExamples.md](UsageExamples.md) — Code snippets and common usage patterns

---

## Documentation Status

**Overall completion**: 0/26 endpoints documented

| Category | Files | Status |
|----------|-------|--------|
| Authentication | 1 | ⏳ Pending |
| Accounts | 3 | ⏳ Pending |
| Safes | 1 | ⏳ Pending |
| Users & Groups | 2 | ⏳ Pending |
| Platforms | 1 | ⏳ Pending |
| Requests | 1 | ⏳ Pending |
| Sessions | 2 | ⏳ Pending |
| Advanced | 7 | ⏳ Pending |
| Operational | 5 | ⏳ Pending |
| Examples | 1 | ⏳ Pending |
| **Total** | **26** | **⏳ Pending** |

---

## How to Use These Files

### For API Consumers

1. **Look up an endpoint**: Find the file matching the resource you need (e.g., "Accounts" for account operations)
2. **Read the Overview**: Get a quick summary of available methods
3. **Choose your method**: SELECT the HTTP method you need (GET, POST, PUT, DELETE)
4. **Review Parameters**: Check what parameters are required/optional
5. **See examples**: Look for code examples in the endpoint or UsageExamples.md

### For API Implementers

1. **Reference the schema**: Use Request Body and Response Codes sections to build your API client
2. **Handle errors**: Implement error handlers for the listed HTTP status codes
3. **Test authentication**: Follow the Authentication section to set up auth in your client
4. **Paginate**: For list endpoints, implement pagination using limit/offset parameters

### For Developers Building Automation

1. **Search by use case**: Find relevant endpoints in api-catalog.md by category
2. **Cross-reference**: Check Related Endpoints section to understand endpoint chains
3. **Batch operations**: Look for bulk endpoints (e.g., BulkUpload) to optimize performance
4. **Error handling**: Implement comprehensive error handling for production workflows

---

## File Format

Every endpoint file includes:

```markdown
# [Endpoint Name]

## Header
File, version, source, status

## Overview
Quick summary table

## Purpose
Business purpose and use cases

## Full Path
Example request paths

## HTTP Method
GET/POST/PUT/DELETE details

## Authentication
Auth requirements

## Parameters
URL, query, and header parameters

## Request Body
JSON schema and field descriptions

## Response Codes
HTTP status codes and meanings

## Notes
Additional information

## Related Endpoints
Links to related operations
```

See `/references/endpoint-template.md` for the full template.

---

## Quick Start Examples

### Get all accounts
```
GET /api/Accounts
Authorization: Bearer <token>
```

See [Accounts.md](Accounts.md) for full details.

### Create a new account
```
POST /api/Accounts
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "admin-prod",
  "address": "prod.example.com",
  "username": "admin",
  "platformId": "UnixSSH",
  "safeId": "Prod-Accounts"
}
```

See [Accounts.md](Accounts.md) for response schema and error codes.

### Authenticate to API
```
POST /api/Auth/Logon
Content-Type: application/json

{
  "username": "api-user",
  "password": "<password>"
}
```

See [Authentication.md](Authentication.md) for token format.

---

## Troubleshooting

### Endpoint file not found
- Check spelling against the file list above
- Look in api-catalog.md for the correct endpoint name
- Verify you're using v12.2 (some endpoints added in later versions)

### Missing endpoint details
- File may be marked as "Pending" — check status column
- Run `Fetch-APIDocumentation.ps1 -Version 12.2` from `/scripts/` to populate from live docs
- Check `references/endpoint-template.md` for the canonical structure

### Authentication failing
- See [Authentication.md](Authentication.md) for auth formats and requirements
- Verify your token/certificate is valid and has permissions
- Check vault audit logs for clues

---

## Contributing

To update an endpoint file:

1. Read the current file
2. Reference the live CyberArk documentation
3. Update the file following the template structure
4. Mark status as "Complete" or "Partial" in the header
5. Commit with a meaningful message

---

**Last Updated**: [Initial scaffold — awaiting documentation fetch]  
**Source**: https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm
