# PTAAdministration

## Header

| Field | Value |
|-------|-------|
| **File** | PTAAdministration.md |
| **Version** | 14.2 |
| **Platform** | Self-Hosted |
| **Source** | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/sdk/api%20commands%20-%20ptaadministration%20web%20services.htm |
| **Build** | 8.3.6 |
| **Status** | Complete |
| **New in v14.2** | Yes |

---

## Overview

| Aspect | Details |
|--------|---------|
| **Method(s)** | GET, PUT, DELETE, POST |
| **Endpoint** | /api/PTA/Administration |
| **Description** | Manage PTA scanner configuration and threat catalogs |
| **Auth Required** | Yes (Admin) |

---

## Purpose

Centralized administration of Privileged Threat Analytics scanners and threat catalogs. Configure scanner properties, manage global threat catalogs, and administer PTA infrastructure via API.

---

## Full Path

### Get Administration Settings
```
GET /api/PTA/Administration
```

### Update Administration Properties
```
PUT /api/PTA/Administration/Properties
```

### Delete Administration Properties
```
DELETE /api/PTA/Administration/Properties
```

### Add Global Catalog
```
POST /api/PTA/Administration/GlobalCatalog
```

### Get Global Catalog
```
GET /api/PTA/Administration/GlobalCatalog
```

---

## HTTP Method

### GET - Retrieve Settings
- **Purpose**: Get PTA admin configuration
- **Body**: None
- **Response**: JSON settings

### PUT - Update Properties
- **Purpose**: Update admin settings
- **Body**: JSON properties
- **Response**: JSON updated settings

### DELETE - Remove Properties
- **Purpose**: Reset settings to default
- **Body**: None
- **Response**: HTTP 204

### POST - Add to Catalog
- **Purpose**: Add threat to global catalog
- **Body**: JSON catalog entry
- **Response**: JSON created entry

### GET - List Catalog
- **Purpose**: Retrieve threat catalog
- **Body**: None
- **Response**: JSON catalog entries

---

## Authentication

**Required**: Yes — Vault Admin only

```
Authorization: CyberArk <admin_token>
```

---

## Request Body

### Update Properties

```json
{
  "ScannerTimeout": 300,
  "AlertThreshold": "HIGH",
  "AutoQuarantine": true,
  "ScanInterval": 24
}
```

### Add to Catalog

```json
{
  "ThreatID": "THREAT_001",
  "ThreatName": "Privileged Account Misuse",
  "Severity": "CRITICAL",
  "Description": "Unauthorized privileged account usage detected",
  "RecommendedAction": "Investigate and revoke access"
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
| 500 | Internal Server Error | Vault error |

---

## Notes

- **Scanner Management**: Configure all deployed PTA scanners centrally
- **Threat Catalog**: Maintain global list of known threats and remediation steps
- **Auto-Quarantine**: Automatically quarantine suspicious accounts (optional)
- **Thresholds**: Tune alert sensitivity per environment needs
- **Audit Trail**: All PTA admin changes logged for compliance

---

## Related Endpoints

- [PTAInstallation.md](PTAInstallation.md) — Scanner installation and status
- [DiscoveredAccounts.md](DiscoveredAccounts.md) — Manage discovered accounts from PTA

---

## Example Usage

### Get PTA Administration Settings
```bash
curl -X GET \
  https://vault.example.com/api/PTA/Administration \
  -H "Authorization: CyberArk <admin_token>"
```

### Update PTA Settings
```bash
curl -X PUT \
  https://vault.example.com/api/PTA/Administration/Properties \
  -H "Authorization: CyberArk <admin_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "ScannerTimeout": 300,
    "AlertThreshold": "HIGH",
    "AutoQuarantine": true
  }'
```

---

**Last Updated**: 2026-05-03
