# CyberArk PAM REST API Reference

This workspace maintains a version-aware library of CyberArk PAM REST API endpoints. It serves as the source of truth for API syntax, authentication, parameters, and response schemas across versions.

## Quick Start

### Finding and Accessing Documentation

**Self-Hosted (On-Premises) API Documentation:**
```
https://docs.cyberark.com/pam-self-hosted/{VERSION}/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm
```

**Privilege Cloud API Documentation:**
```
https://docs.cyberark.com/privilege-cloud-standard/latest/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm
```

**Note**: Privilege Cloud uses `latest` (continuous updates, not version-specific).

**Self-Hosted examples:**
- v12.2: https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/...
- v14.2: https://docs.cyberark.com/pam-self-hosted/14.2/en/content/webservices/...
- v14.4: https://docs.cyberark.com/pam-self-hosted/14.4/en/content/webservices/...

**Privilege Cloud examples:**
- Latest: https://docs.cyberark.com/privilege-cloud-standard/latest/en/content/webservices/...

**Fetch with curl** (not automated web tools):
```bash
curl -s -L \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
  "https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm"
```

### ⚠️ Note on Fetch-APIDocumentation.ps1

This script does NOT work (CyberArk docs return 404 to automated tools). Endpoint files are created manually using the methodology described in CLAUDE.md.

### Reference an Endpoint

Navigate to `versions/self-hosted/v12.2/endpoints/Accounts.md` to see:
- Full endpoint path
- HTTP method
- Required authentication
- URL, query, and header parameters
- Request/response schemas
- Error codes
- Related endpoints

### Create a New Version

**Self-Hosted:**
```powershell
.\scripts\New-APIVersion.ps1 -Version 14.4
```

**Privilege Cloud:**
```powershell
.\scripts\New-APIVersion.ps1 -Version 24.1 -Platform PC
```

This creates the version folder with api-catalog.md and changelog.md.

### Compare Two Versions

**Same platform (most common):**
```powershell
.\scripts\Compare-APIVersions.ps1 -From 12.2 -To 14.2
```

**Cross-platform comparison:**
```powershell
.\scripts\Compare-APIVersions.ps1 -From 14.2 -FromPlatform SH -To 14.2 -ToPlatform PC
```

Output: `exports/comparison_[platform]_v[X.X]_to_v[X.X]_YYYYMMDD.md`

## Version Status

| Platform | Version | Status | Build | Endpoints | Last Updated |
|----------|---------|--------|-------|-----------|--------------|
| Self-Hosted | v12.2 | Complete | 8.2.5 | 25/25 | 2026-05-03 |
| Self-Hosted | v14.2 | Complete | 8.3.6 | 28/28 | 2026-05-03 |
| Self-Hosted | v14.4 | Structure only | — | — | — |
| Privilege Cloud | (none yet) | — | — | — | — |

## Folder Guide

- **scripts/**: PowerShell utilities (fetch, compare, version management)
- **references/**: Templates and boilerplate (endpoint-template.md, manager-report-template.md, developer-report-template.md)
- **versions/**: API documentation organized by platform and version
  - `README.md` — Index of all versions and platforms
  - `version-tracking.md` — Endpoint completion checklist per platform
  - `self-hosted/` — Self-Hosted (on-prem) API documentation
    - `v12.2/`, `v14.2/`, `v14.4/` — Endpoint documentation per version
  - `privilege-cloud/` — Privilege Cloud API documentation
- **reports/**: Finalized deliverables
  - `manager/` — Executive summary reports for stakeholders
  - `developer/` — Technical migration guides for engineers
- **exports/**: Script output (raw comparison data)
- **tmp/**: Scratch space (git-ignored)

## Endpoint Documentation Format

Each endpoint file (`v12.2/endpoints/Accounts.md`, etc.) includes:

```markdown
# [Endpoint Name]

## Header
- **File**: Accounts.md
- **Version**: 12.2
- **Source**: https://docs.cyberark.com/...
- **Status**: Complete/Partial

## Overview
| Aspect | Value |
|--------|-------|
| Method | GET, POST, PUT, DELETE |
| Endpoint | /api/Accounts |
| Description | Manage vault accounts |
| Auth Required | Yes |

## Purpose
[What this endpoint does]

## Full Path
[Example paths with variables]

## HTTP Method
[Method details]

## Authentication
[Auth requirements]

## Parameters
[URL, query, header params]

## Request Body
[JSON schema, field descriptions]

## Response Codes
[HTTP codes and meanings]

## Related Endpoints
[Links to related operations]
```

## Using in Other Workflows

Other workflows (cyberark-api module, psPAS pipeline, custom automation) reference these docs:

```powershell
# Example: Look up Accounts endpoint in psPAS workflow (Self-Hosted v12.2)
Get-Content "$ApiEvalPath\versions\self-hosted\v12.2\endpoints\Accounts.md"

# Example: Look up endpoint for current environment (from _config/environment.md)
$platform = if ($environment.deploymentModel -eq 'Privilege Cloud') { 'privilege-cloud' } else { 'self-hosted' }
Get-Content "$ApiEvalPath\versions\$platform\v$version\endpoints\Accounts.md"
```

The markdown format makes it human-readable and easy to parse in scripts.

## CyberArk Documentation Sources

- **v12.2**: https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm
- **v14.2**: https://docs.cyberark.com/pam-self-hosted/14.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm
- **v14.4**: https://docs.cyberark.com/pam-self-hosted/14.4/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm

## Notes

- This workspace is for **documentation only** — do not make API calls here
- Live API interactions belong in the `cyberark-api` module or `psPAS` workflow
- All endpoint docs are human-readable markdown; scripts can reference them programmatically
