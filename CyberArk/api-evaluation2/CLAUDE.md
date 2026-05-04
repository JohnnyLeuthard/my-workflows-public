# API Evaluation — CyberArk REST API Version Tracking

You are in a reference sub-workspace of the CyberArk operations workspace. This folder documents CyberArk PAM REST API endpoints across versions (v12.2, v14.2.1, v14.4) to serve as a source of truth for downstream workflows.

## Identity

- **Purpose**: Version-aware API endpoint reference library
- **Consumers**: cyberark-api (module), psPAS (remediation), custom automation workflows
- **Scope**: REST API documentation, version tracking, change analysis
- **Outputs**: Markdown reference docs, HTML comparison reports, version diff exports

## How to Use This Workspace

### Finding Documentation

**CyberArk API Documentation URLs** by platform:

**Self-Hosted (On-Premises):**
```
https://docs.cyberark.com/pam-self-hosted/{VERSION}/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm
```

**Privilege Cloud:**
```
https://docs.cyberark.com/privilege-cloud-standard/latest/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm
```

**Note**: Privilege Cloud uses `latest` (not version-specific) because updates are continuous.

**Supported versions:**
- Self-Hosted: 12.2, 14.2, 14.4 (and future releases)
- Privilege Cloud: 14.2, 24.1, 24.2 (and future releases)

**Examples:**
- Self-Hosted v12.2: https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/...
- Privilege Cloud (latest): https://docs.cyberark.com/privilege-cloud-standard/latest/en/content/webservices/...

**Note:** Fetch these with `curl` using a browser User-Agent header. Do NOT use automated web-fetch tools — they will return 404 due to CyberArk's content delivery restrictions.

### Working with Versions

1. **Identify new version**: Check CyberArk release notes at docs.cyberark.com
2. **Determine platform**: Self-Hosted (SH) or Privilege Cloud (PC)
3. **Create folder**: 
   - Self-Hosted: `scripts/New-APIVersion.ps1 -Version {X.X}`
   - Privilege Cloud: `scripts/New-APIVersion.ps1 -Version {X.X} -Platform PC`
4. **Populate endpoints**: Manually create endpoint .md files using endpoint-template.md (see methodology below)
5. **Compare versions**: 
   - Same platform: `scripts/Compare-APIVersions.ps1 -From 12.2 -To 14.2`
   - Cross-platform: `scripts/Compare-APIVersions.ps1 -From 14.2 -FromPlatform SH -To 14.2 -ToPlatform PC`
6. **Reference in workflows**: Point to `versions/self-hosted/vX.X/endpoints/*.md` or `versions/privilege-cloud/vX.X/endpoints/*.md`

## File Organization

```
api-evaluation2/
├── scripts/                  PowerShell utilities for version management
├── references/              Templates and guidance docs
├── versions/                API documentation by platform and version
│   ├── README.md           Index of all versions and platforms
│   ├── version-tracking.md Endpoint completion checklist per platform
│   ├── self-hosted/        Self-Hosted (on-prem) API documentation
│   │   ├── v12.2/          Endpoint docs for v12.2
│   │   ├── v14.2/          Endpoint docs for v14.2
│   │   └── v14.4/          Endpoint docs for v14.4 (structure only)
│   └── privilege-cloud/    Privilege Cloud API documentation
│       └── (versions to be documented)
├── reports/               Finalized comparison reports
│   ├── manager/          Executive summary reports (for stakeholders)
│   └── developer/        Technical migration guides (for engineers)
├── exports/              Script output (raw comparison data)
└── tmp/                  Scratch space (git-ignored)
```

## Key Rules

1. **Version folders are self-contained**: Each `platform/vX.X/` holds a complete API snapshot for that platform
2. **Platform separation**: Self-Hosted and Privilege Cloud versions are in separate folders
3. `endpoint-template.md` is the canonical format for all endpoint docs (includes Platform field)
4. Scripts support `-WhatIf` (preview) and `-Force` (skip confirmation)
5. All scripts accept `-Platform SH|PC` parameter to target the right folder
6. CyberArk docs URLs use major.minor only (`12.2`, `14.2`, `14.4`, `24.1`)
7. `tmp/` is scratch; do not commit its contents

## Finding New or Missing Endpoints

**For a new Self-Hosted version** (e.g., v14.2 when only v12.2 exists):

1. Run `New-APIVersion.ps1 -Version 14.2 -CopyFrom 12.2`
2. This creates `self-hosted/v14.2/` and copies all 25 endpoints from v12.2
3. Review v14.2 changelog/release notes to identify new endpoints
4. Create new endpoint .md files for v14.2-specific features (see endpoint-template.md)
5. Update `versions/self-hosted/v14.2/changelog.md` with breaking changes and new endpoints

**For a new Privilege Cloud version**:

1. Run `New-APIVersion.ps1 -Version 24.1 -Platform PC`
2. This creates `privilege-cloud/v24.1/` with empty endpoints folder
3. Manually create all endpoint .md files (no copy, as PC is not based on SH)
4. Follow endpoint-template.md structure
5. Update `versions/privilege-cloud/v24.1/changelog.md`

**For missing endpoints in an existing version**:

1. Check `versions/{platform}/vX.X/endpoints/README.md` for what's documented
2. Use `versions/{platform}/vX.X/api-catalog.md` to see full endpoint list
3. If endpoint is missing, follow endpoint-template.md to create it
4. Mark `Platform | Self-Hosted` or `Platform | Privilege Cloud` in file header
5. Validate against CyberArk documentation for accuracy

## Methodology: Creating Endpoint Files

**This is NOT a fetch/parse operation.** Endpoint files are created by hand using the template structure, populated with real API specifications from either:

1. **Live CyberArk docs** (via curl with User-Agent header to bypass 404s)
2. **Your vault instance** (Swagger API at `https://{vault}/PasswordVault/swagger/`)
3. **Knowledge of the API** (if docs are unavailable)

**Do NOT:**
- Use incomplete stub files
- Leave TODO or placeholder sections
- Skip required documentation sections
- Mark status as "Partial" when it should be "Complete"

**Each endpoint file MUST include:**
- Header with version, **platform**, source, build, status="Complete"
- Overview table (methods, path, description, auth)
- Purpose (business context)
- Full Path (with examples)
- HTTP Methods (GET/POST/PUT/DELETE details)
- Authentication (type, headers, examples)
- Parameters (URL, query, headers as tables)
- Request Body (JSON schema + field descriptions + constraints)
- Response Codes (HTTP codes as table)
- Notes (pagination, security, edge cases)
- Related Endpoints (cross-references)
- Example Usage (curl/bash/Python)

## No Execution Here

This workspace documents the API; it does not call it. Live API operations belong in `cyberark-api` or `psPAS` workflows, which reference these docs.

## Cross-Workspace Context: Current Version & Platform

**When you need to know which CyberArk version and platform are currently deployed:**

1. Check `CyberArk/_config/environment.md`:
   - Read the **Deployment Model** column (Self-hosted or Privilege Cloud) per environment tier
   - Read the **Vault/PVWA version** per environment tier
2. Based on Deployment Model, look in the correct platform folder:
   - Self-Hosted: `versions/self-hosted/v{VERSION}/`
   - Privilege Cloud: `versions/privilege-cloud/v{VERSION}/`
3. If that version is NOT yet documented:
   - ⚠️ **Warning**: The current environment version is not yet evaluated in this workspace
   - Check the vendor docs directly (correct URL per platform):
     - Self-Hosted: `https://docs.cyberark.com/pam-self-hosted/{VERSION}/en/content/webservices/...`
     - Privilege Cloud: `https://docs.cyberark.com/privilege-cloud/{VERSION}/en/content/webservices/...`
   - Use curl with User-Agent header, not automated tools
   - Follow the process in `versions/version-tracking.md` "How to Add a [Platform] Version" to document when ready

**Example:**
- environment.md shows Deployment Model = Self-hosted, PVWA version = 14.4.2
- Look in `versions/self-hosted/v14.4/`
- v14.4 structure exists but endpoints not yet documented
- Use vendor docs until `versions/self-hosted/v14.4/endpoints/` is populated

**Important**: Do NOT load environment.md in the system prompt by default. Only reference it when working on API-version-dependent tasks. Load it lazily when checking current version.
