# API Version Tracking

Tracks which CyberArk versions are documented in this workspace and their endpoint completion status. Updated when new versions are discovered and evaluated.

## Platform Index

Quick reference for which platforms have which versions documented.

| Platform | Versions Documented | Latest | Endpoint Count | Section |
|----------|--------------------|----|---|---|
| Self-Hosted | v12.2, v14.2 | v14.2 | 25 + 28 = 53 | [Self-Hosted](#self-hosted) |
| Privilege Cloud | (none yet) | — | — | [Privilege Cloud](#privilege-cloud) |

---

## Self-Hosted

### Version Inventory

| Version | Folder | Platform | Status | Build | Endpoints | Last Updated | Notes |
|---------|--------|----------|--------|-------|-----------|--------------|-------|
| v12.2 | self-hosted/v12.2/ | Self-Hosted | Complete | 8.2.5 | 25/25 | 2026-05-03 | Baseline version, fully documented |
| v14.2 | self-hosted/v14.2/ | Self-Hosted | Complete | 8.3.6 | 28/28 | 2026-05-03 | +3 new endpoint groups, fully documented |

### Endpoint Checklist — v12.2 (25 endpoints)

- [x] AccountActions.md
- [x] AccountGroups.md
- [x] Accounts.md
- [x] Applications.md
- [x] Authentication.md
- [x] BulkUpload.md
- [x] DiscoveredAccounts.md
- [x] General.md
- [x] Groups.md
- [x] LDAPIntegration.md
- [x] LinkedAccounts.md
- [x] MonitorSessions.md
- [x] OnboardingRules.md
- [x] OPMCommands.md
- [x] Platforms.md
- [x] PTAInstallation.md
- [x] Requests.md
- [x] Safes.md
- [x] Security.md
- [x] Server.md
- [x] SessionManagement.md
- [x] SSHKeys.md
- [x] SystemHealth.md
- [x] UsageExamples.md
- [x] Users.md

### Endpoint Checklist — v14.2 (25 from v12.2 + 3 new = 28 endpoints)

**From v12.2** (all copied and updated to v14.2):
- [x] AccountActions.md
- [x] AccountGroups.md
- [x] Accounts.md
- [x] Applications.md
- [x] Authentication.md
- [x] BulkUpload.md
- [x] DiscoveredAccounts.md
- [x] General.md
- [x] Groups.md
- [x] LDAPIntegration.md
- [x] LinkedAccounts.md
- [x] MonitorSessions.md
- [x] OnboardingRules.md
- [x] OPMCommands.md
- [x] Platforms.md
- [x] PTAInstallation.md
- [x] Requests.md
- [x] Safes.md
- [x] Security.md
- [x] Server.md
- [x] SessionManagement.md
- [x] SSHKeys.md
- [x] SystemHealth.md
- [x] UsageExamples.md
- [x] Users.md

**New in v14.2**:
- [x] AuthenticationMethodsConfiguration.md (5 endpoints)
- [x] AccountSecretVersions.md (1 endpoint)
- [x] PTAAdministration.md (5 endpoints)

### New Endpoints by Version (Self-Hosted)

#### v14.2 (vs v12.2)

**Authentication Methods Configuration**
- GET /api/Configuration/AuthenticationMethods
- GET /api/Configuration/AuthenticationMethods/{id}
- POST /api/Configuration/AuthenticationMethods
- PUT /api/Configuration/AuthenticationMethods/{id}
- DELETE /api/Configuration/AuthenticationMethods/{id}

**Accounts: Secret Versions**
- GET /api/Accounts/{id}/Secret/Versions

**PTA Administration**
- GET /api/PTA/Administration
- PUT /api/PTA/Administration/Properties
- DELETE /api/PTA/Administration/Properties
- POST /api/PTA/Administration/GlobalCatalog
- GET /api/PTA/Administration/GlobalCatalog

---

## Privilege Cloud

### Version Inventory

| Version | Folder | Platform | Status | Build | Endpoints | Last Updated | Notes |
|---------|--------|----------|--------|-------|-----------|--------------|-------|
| (none yet) | — | Privilege Cloud | — | — | — | — | First PC version awaiting documentation |

### How to Add a Privilege Cloud Version

When a new Privilege Cloud version is discovered or needs documentation:

1. **Check CyberArk Privilege Cloud docs**: `https://docs.cyberark.com/privilege-cloud/{VERSION}/en/content/webservices/...`
2. **Note the build number** from the documentation page
3. **Run**: `scripts/New-APIVersion.ps1 -Version {X.X} -Platform PC`
   - Script creates `privilege-cloud/v{X.X}/` folder structure
   - Copies api-catalog.md and changelog.md templates
4. **Populate endpoints** following the same process as Self-Hosted:
   - Manually create endpoint .md files using endpoint-template.md
   - Follow the 12-section structure: Header, Overview, Purpose, Full Path, HTTP Methods, Authentication, Parameters, Request Body, Response Codes, Notes, Related Endpoints, Example Usage
   - Each file 400-800 lines, no stubs/TODOs
   - Mark `Platform | Privilege Cloud` in each file header
5. **Update this file**:
   - Add row to **Version Inventory** table above
   - Create **Endpoint Checklist** section for the new version
   - Add **New Endpoints** section listing endpoints new in this PC version
6. **Commit and merge** the new version folder

---

## How to Update This File

When processing a new version (Self-Hosted or Privilege Cloud):

1. **Add row to Version Inventory** table with: version, folder, platform, status, build, endpoint count, last updated date, notes
2. **Create Endpoint Checklist** section — copy structure from existing version, update version number
3. **Mark endpoints complete** with [x] as they are documented (start with [ ] unchecked)
4. **Add New Endpoints section** listing what's added in this version vs previous
5. **Update Platform Index** at top to reflect new version count

---

**Last Updated**: 2026-05-03
