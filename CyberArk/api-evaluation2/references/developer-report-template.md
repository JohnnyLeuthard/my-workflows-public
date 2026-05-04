# Developer Migration Report: [Platform] v[X.X] → v[X.X]

**Platform**: Self-Hosted / Privilege Cloud  
**Report Date**: [Date]  
**From Version**: v[X.X] (Build [X.X.X])  
**To Version**: v[X.X] (Build [X.X.X])  
**Audience**: Engineers, integration owners, API consumers  
**Generated**: [Date] | Data source: `exports/comparison_[platform]_v[X.X]_to_v[X.X]_[date].md`

---

## At a Glance

Quick metrics to understand the scope of changes needed.

| Item | Count | Effort |
|------|-------|--------|
| Breaking changes | N | Must fix before upgrade |
| New endpoints available | N | Optional adoption |
| Endpoints removed | N | Migration required |
| Parameters changed | N | Code review required |
| **Overall code change effort** | Low / Medium / High | Estimated impact |

---

## Breaking Changes — Act Before Upgrading

Changes that will break existing code if not addressed. Must be fixed before or during upgrade.

### [Endpoint Name]

**What changed**: [Specific, concrete description of what changed]

**Your code impact**: [What will break if you do nothing]

**Fix**: [Exact change required — parameter rename, schema update, error handling change, etc.]

**Code example**:

```powershell
# Before (v[X.X])
$params = @{
  AccountID = 123
  OldParam  = "value"
}
Invoke-RestMethod -Uri "https://vault/api/Accounts/$($params.AccountID)" -Body $params

# After (v[X.X])
$params = @{
  AccountID = 123
  NewParam  = "value"    # Renamed from OldParam
}
Invoke-RestMethod -Uri "https://vault/api/Accounts/$($params.AccountID)" -Body $params
```

**Timeline**: Fixed in release v[X.X.X] on [Date]  
**Reference**: See `versions/[platform]/v[X.X]/endpoints/[Name].md` for full endpoint spec

---

## New Endpoints — Optional Adoption

New endpoints that may benefit your code. Adoption is optional; existing endpoints still work.

### [Endpoint Name]

**HTTP Method & Path**: `GET /api/[Resource]/{id}`

**What it does**: [Description of the new endpoint]

**When to use it**: [Use case — when would this be better than current approach?]

**Example**:

```powershell
# New approach (v[X.X]+)
$response = Invoke-RestMethod -Uri "https://vault/api/[Resource]/123" `
  -Headers @{ Authorization = "CyberArk $token" }

# Old approach (still works)
$response = Invoke-RestMethod -Uri "https://vault/api/[Resource]" `
  -Body @{ id = 123 } -Headers @{ Authorization = "CyberArk $token" }
```

**Reference**: `versions/[platform]/v[X.X]/endpoints/[Name].md`

---

## Removed Endpoints — Migration Required

Endpoints that are no longer available. Must migrate to replacement.

### [Endpoint Name]

**Last available in**: v[X.X]

**Replacement**: [New endpoint path] or [Legacy endpoint still works as fallback]

**Migration steps**:

1. Identify all code calling `/api/[OldEndpoint]`
2. Replace with call to `/api/[NewEndpoint]` and update parameter names
3. Test against DEV to confirm behavior matches
4. Validate error handling (response codes may differ)
5. Update psPAS module references if applicable

**Code example**:

```powershell
# Old (removed in v[X.X])
$response = Invoke-RestMethod -Uri "https://vault/api/[OldEndpoint]" -Body @{ ... }

# New replacement
$response = Invoke-RestMethod -Uri "https://vault/api/[NewEndpoint]" -Body @{ ... }
```

**Reference**: See `versions/[platform]/v[X.X-1]/endpoints/[Name].md` for old spec

---

## Parameter Changes — Review and Update

Parameters that changed name, type, or behavior. Requires code review.

| Endpoint | Parameter | Change Type | Old Value | New Value | Code Impact |
|----------|-----------|-------------|-----------|-----------|-------------|
| /api/Accounts | AccountID | Type change | string | integer | Must cast strings to int |
| /api/Accounts | ExpiryDate | New format | "YYYY-MM-DD" | "YYYY-MM-DDTHH:MM:SSZ" | Update date formatting |
| /api/Requests | ApproverID | Removed | required | N/A | Remove from request body |

---

## Authentication Changes

If authentication method or headers changed in this version.

### [If Applicable]

**Old auth method** (v[X.X]):
```powershell
$headers = @{
  Authorization = "CyberArk $sessionToken"
}
```

**New auth method** (v[X.X]):
```powershell
$headers = @{
  Authorization = "Bearer $jwtToken"
}
```

**Migration**: Ensure your session management code is updated to generate the new token format.

---

## Response Format Changes

If the response structure changed significantly.

### [If Applicable]

**Old response** (v[X.X]):
```json
{
  "AccountID": 123,
  "AccountName": "admin@domain.com"
}
```

**New response** (v[X.X]):
```json
{
  "id": 123,
  "name": "admin@domain.com",
  "metadata": {
    "createdBy": "...",
    "createdDate": "..."
  }
}
```

**Migration**: Update JSON parsing and field mappings in your code.

---

## Migration Checklist

Use this checklist to track your migration work.

### Pre-Upgrade (Dev Environment)

- [ ] Review "Breaking Changes" section — do any apply to your code?
- [ ] Identify all API calls that need updating
- [ ] Create feature branch: `git checkout -b upgrade/v[X.X]-to-v[X.X]`
- [ ] Update auth token generation (if auth changed)
- [ ] Update endpoint paths (if endpoints removed/renamed)
- [ ] Update parameter names and types
- [ ] Update JSON parsing for response schema changes
- [ ] Update error handling (status codes may differ)

### Testing in Dev

- [ ] Build and test against v[X.X] in DEV
- [ ] Run existing integration tests — all should pass
- [ ] Test new optional endpoints (if adopting)
- [ ] Test edge cases (empty responses, large payloads, etc.)
- [ ] Run load/stress tests if applicable

### Pre-Production Testing

- [ ] Code review on upgrade branch
- [ ] Test against v[X.X] in UAT
- [ ] Get approval from [Owner] before production
- [ ] Create runbook for rollback if issues occur

### Post-Upgrade

- [ ] Monitor production logs for API errors
- [ ] Test critical business flows end-to-end
- [ ] Confirm all metrics/dashboards still working
- [ ] Document any workarounds or known issues

---

## Code Review Areas

Areas that often have issues during version upgrades.

- [ ] **Auth flow**: Token generation, session management, MFA handling
- [ ] **Error handling**: New error codes or messages to handle?
- [ ] **Pagination**: Do limit/offset parameters still work the same way?
- [ ] **Filtering**: Query string parameters — any name or type changes?
- [ ] **Date formats**: Any ISO 8601 vs custom format changes?
- [ ] **Null handling**: New nullable fields that old code may not expect?
- [ ] **Rate limiting**: New rate limit headers or behaviors?

---

## Related Resources

- **Full endpoint specs**: `versions/[platform]/v[X.X]/endpoints/`
- **Change summary**: `versions/[platform]/v[X.X]/changelog.md`
- **Manager report**: `reports/manager/manager_[platform]_v[X.X]_to_v[X.X]_[date].md`
- **Raw comparison data**: `exports/comparison_[platform]_v[X.X]_to_v[X.X]_[date].md`
- **CyberArk official release notes**: https://docs.cyberark.com/

---

**Last Updated**: [Date]  
**Template Version**: 1.0
