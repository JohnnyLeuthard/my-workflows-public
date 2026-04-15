# Master Policy Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: Typically stored as key-value pairs or in a dedicated table
> **Export File**: `MasterPolicySettings.txt`
> **Vendor Docs**: [Master Policy Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/master-policy-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains the Master Policy settings that define the global password management policies across the Vault. These settings control CPM behavior, session management, and compliance rules at the platform level.

---

## Columns (Out-of-Box)

| # | Column | Description |
|---|--------|-------------|
| 1 | PolicyID | Platform policy identifier (e.g., `WinDomain`, `UnixSSH`, `Oracle`) |
| 2 | SettingName | Name of the policy setting |
| 3 | SettingValue | Current value of the setting |
| 4 | SettingType | Data type of the setting |
| 5 | VaultID | Vault instance identifier |

---

## Common Master Policy Settings

### Password Management

| Setting | Description | Typical Values |
|---------|-------------|----------------|
| RequirePasswordChange | Require periodic password changes | Yes/No |
| RequirePasswordVerification | Require periodic password verification | Yes/No |
| PasswordChangeInterval | Days between password changes | 30, 60, 90 |
| PasswordVerificationInterval | Days between password verifications | 7, 14 |
| RequirePasswordReconciliation | Enable automatic reconciliation on failure | Yes/No |
| HeadStartInterval | Minutes before change to start early | 5 |

### Session Management

| Setting | Description | Typical Values |
|---------|-------------|----------------|
| RequirePrivilegedSessionMonitoring | Require PSM for connections | Yes/No |
| PSMRecordingOnTransparentConnections | Record transparent connections | Yes/No |
| AuditUsers | Audit privileged user activity | Yes/No |

### Compliance

| Setting | Description | Typical Values |
|---------|-------------|----------------|
| EnforceCheckinCheckout | Require exclusive access | Yes/No |
| EnforceOnetimePassword | One-time password use | Yes/No |
| RequireDualControl | Require dual-control approval | Yes/No |

---

## Usage Notes

- Master Policy defines the **default** settings — individual platforms can override these
- This report is useful for compliance audits to verify policy configuration
- Settings not listed here may be platform-specific extensions
- The export format may vary from the standard tabular EVD format
