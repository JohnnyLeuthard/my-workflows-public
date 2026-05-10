# Developer Migration Guide: CyberArk Self-Hosted v12.2 → v14.2

**Platform**: Self-Hosted  
**Report Date**: May 10, 2026  
**From Version**: v12.2 (Build 8.2.5)  
**To Version**: v14.2 (Build 8.3.6)  
**Audience**: Engineers, integration owners, API consumers  
**Data Source**: `exports/comparison_sh-v12.2_to_sh-v14.2_20260510.md`

---

## At a Glance

The upgrade from v12.2 to v14.2 adds three new endpoints without removing or breaking existing ones. All 25 endpoints from v12.2 remain functional and compatible. The upgrade is low-risk for existing integrations.

| Item | Count | Assessment |
|------|-------|------------|
| Breaking changes | 0 | No action required |
| New endpoints available | 3 | Optional adoption |
| Endpoints removed | 0 | Full compatibility |
| Core API compatibility | 25/25 | No deprecations |
| **Overall migration effort** | Low | Safe to upgrade |

---

## New Endpoints — Evaluate for Adoption

Three new endpoints are available in v14.2. Adoption is optional; existing code continues to work without changes.

### 1. AccountSecretVersions

**Endpoint**: `GET /api/Accounts/{AccountID}/Secret/Versions`

**What it does**: Retrieve the password change history for an account, including timestamps and version metadata. Useful for compliance audits, incident investigations, and tracking secret rotation.

**When to adopt**: If your organization needs to audit password history or implement rotation tracking without querying external systems.

**Parameters**:
- `AccountID` (required): The account ID
- `limit` (optional): Number of versions per page (default 50)
- `offset` (optional): Pagination offset (default 0)

**Example**:

```powershell
# Retrieve password history for account 123
$response = Invoke-RestMethod `
  -Uri "https://vault/api/Accounts/123/Secret/Versions?limit=100" `
  -Headers @{ Authorization = "CyberArk $sessionToken" } `
  -Method Get

# Returns array of version objects with timestamps
$response | ForEach-Object {
  Write-Host "Version: $($_.VersionNumber) - Changed: $($_.ChangeTime)"
}
```

**Reference**: `versions/self-hosted/v14.2/endpoints/AccountSecretVersions.md`

---

### 2. AuthenticationMethodsConfiguration

**Endpoint**: `GET /api/AuthenticationMethodsConfiguration`, `PUT /api/AuthenticationMethodsConfiguration`

**What it does**: Manage global authentication method settings (MFA requirements, session timeouts, allowed authentication types). Enables programmatic control over vault-wide authentication policies.

**When to adopt**: If you need to enforce authentication policies across your vault or integrate authentication configuration into your IAM workflows.

**Methods**:
- **GET**: Retrieve current authentication method configuration
- **PUT**: Update authentication method settings

**Example**:

```powershell
# Get current authentication configuration
$currentConfig = Invoke-RestMethod `
  -Uri "https://vault/api/AuthenticationMethodsConfiguration" `
  -Headers @{ Authorization = "CyberArk $sessionToken" } `
  -Method Get

# Update to require MFA for all users
$newConfig = @{
  RequireMFA = $true
  SessionTimeout = 30
  AllowedMethods = @("LDAP", "SAML", "OTP")
}

$response = Invoke-RestMethod `
  -Uri "https://vault/api/AuthenticationMethodsConfiguration" `
  -Headers @{ Authorization = "CyberArk $sessionToken" } `
  -Method Put `
  -Body ($newConfig | ConvertTo-Json)
```

**Reference**: `versions/self-hosted/v14.2/endpoints/AuthenticationMethodsConfiguration.md`

---

### 3. PTAAdministration

**Endpoint**: `GET /api/PTAAdministration`, `PUT /api/PTAAdministration`

**What it does**: Manage Privileged Threat Analytics settings (threat detection thresholds, alerting rules, policy enforcement). Enables programmatic tuning of PTA behavior without UI access.

**When to adopt**: If you run Privilege Threat Analytics and need to adjust detection policies or integrate PTA configuration into your security operations workflow.

**Methods**:
- **GET**: Retrieve current PTA configuration
- **PUT**: Update PTA detection thresholds and policies

**Example**:

```powershell
# Get current PTA settings
$ptaConfig = Invoke-RestMethod `
  -Uri "https://vault/api/PTAAdministration" `
  -Headers @{ Authorization = "CyberArk $sessionToken" } `
  -Method Get

# Adjust threat detection sensitivity
$ptaConfig.ThreatThreshold = "Medium"
$ptaConfig.AlertOnSuspiciousActivity = $true

$response = Invoke-RestMethod `
  -Uri "https://vault/api/PTAAdministration" `
  -Headers @{ Authorization = "CyberArk $sessionToken" } `
  -Method Put `
  -Body ($ptaConfig | ConvertTo-Json)
```

**Reference**: `versions/self-hosted/v14.2/endpoints/PTAAdministration.md`

---

## Existing Endpoints — No Breaking Changes

All 25 endpoints from v12.2 remain fully compatible. No changes to paths, required parameters, response formats, or authentication methods.

**Verified compatible endpoints**:

AccountActions, AccountGroups, Accounts, Applications, Authentication, BulkUpload, DiscoveredAccounts, General, Groups, LDAPIntegration, LinkedAccounts, MonitorSessions, OnboardingRules, OPMCommands, Platforms, PTAInstallation, Requests, Safes, Security, Server, SessionManagement, SSHKeys, SystemHealth, UsageExamples, Users

**Action required**: None. Existing integrations do not need code changes.

---

## Migration Checklist

### Pre-Upgrade Assessment

- [ ] Review the three new endpoints above
- [ ] Assess whether any new endpoints benefit your current workflows
- [ ] Confirm no code depends on endpoints listed as removed (there are none)
- [ ] Check for any custom auth token generation that might conflict

### Testing in Dev

- [ ] Deploy v14.2 to DEV environment
- [ ] Run existing integration tests against all 25 common endpoints
- [ ] Test all results pass without code changes
- [ ] If adopting new endpoints, test them in isolation first
- [ ] Test new endpoints with your authentication method (session tokens, LDAP, SAML)

### Pre-Production

- [ ] Code review (if adopting new endpoints)
- [ ] Test against v14.2 in UAT with live data
- [ ] Run load tests to confirm performance is consistent
- [ ] Get sign-off from operations team before production deployment

### Upgrade Execution

- [ ] Schedule maintenance window if required by your deployment
- [ ] Verify all custom scripts still execute without error
- [ ] Monitor API error logs for the first 24 hours
- [ ] Test critical workflows end-to-end
- [ ] Confirm all metrics and dashboards are still updating

### Post-Upgrade

- [ ] Collect baseline performance metrics (API latency, throughput, error rates)
- [ ] Document any workarounds or issues discovered
- [ ] Update internal API documentation to reference v14.2 endpoints
- [ ] Archive v12.2 endpoint docs for historical reference

---

## Code Review Checklist

Areas to focus on when reviewing v14.2 code.

- [ ] **Auth flow**: Confirm session token generation still works (no breaking changes)
- [ ] **Error handling**: Test response codes for existing endpoints (should match v12.2)
- [ ] **Pagination**: Limit/offset parameters work the same for list endpoints
- [ ] **Date formats**: No changes to ISO 8601 formatting across endpoints
- [ ] **Null handling**: New optional fields shouldn't break existing parsing logic
- [ ] **Rate limiting**: Confirm rate limit headers are present and consistent

---

## Related Resources

- **Full endpoint specifications**: `versions/self-hosted/v14.2/endpoints/`
- **Version changelog**: `versions/self-hosted/v14.2/changelog.md`
- **Raw comparison data**: `exports/comparison_sh-v12.2_to_sh-v14.2_20260510.md`
- **Manager summary**: `reports/manager/` (stakeholder-focused overview)
- **CyberArk official docs**: https://docs.cyberark.com/pam-self-hosted/14.2/

---

**Last Updated**: May 10, 2026  
**Template Version**: 1.0  
**Generated By**: Compare-APIVersions.ps1 + Developer Report Generator
