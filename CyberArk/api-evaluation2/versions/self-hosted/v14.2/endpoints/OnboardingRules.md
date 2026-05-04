# OnboardingRules

## Header

| Field | Value |
|-------|-------|
| **File** | OnboardingRules.md |
| **Version | 14.2 |
| **Source** | https://docs.cyberark.com/pam-self-hosted/12.2 |
| **Build | 8.3.6 |
| **Status** | Complete |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, POST, PUT, DELETE |
| **Endpoint** | /api/OnboardingRules |
| **Description** | Define automated account discovery and onboarding rules |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Create rules for automatic discovery and onboarding of accounts found on target systems.

---

## Full Path

```
GET /api/OnboardingRules
POST /api/OnboardingRules
PUT /api/OnboardingRules/{RuleID}
DELETE /api/OnboardingRules/{RuleID}
```

---

## Request Body

```json
{
  "RuleName": "ProductionServers",
  "TargetPlatform": "UnixSSH",
  "TargetSafe": "ProdAccounts",
  "AutoOnboard": true
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | GET or PUT success |
| 201 | Created | POST success |
| 204 | No Content | DELETE success |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Invalid token |
| 403 | Forbidden | No admin permission |
| 404 | Not Found | Rule not found |
| 500 | Internal Server Error | Vault error |

---

**Last Updated**: 2026-05-03
