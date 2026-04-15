# Compliance Report — EXAMPLE FILE

> **This is an example file, not real pipeline output.**
> It shows what `compliance_report.md` looks like after Stage 3 runs.
> Use it to understand the expected format before running your first compliance analysis.

---

**Source data**: `stages/02_data_fetch/output/vault_data.csv`
**Naming standards**: `references/naming_standards.md`
**Generated**: 2026-04-04

---

## Summary

| Severity | Count |
|----------|-------|
| High     | 4     |
| Medium   | 3     |
| Low      | 1     |
| **Total**| **8** |

---

## High Severity Findings

### NS-P02 — Platform ID Missing

> **Rule**: Account must have a non-blank PolicyID (platform assignment).
> **Severity**: High

| Safe | Account | Current Platform | Violation |
|------|---------|-----------------|-----------|
| SA-Linux-Prod | Operating System-LinuxSSH-svc_backup-server03 | *(blank)* | PolicyID is absent — account has no platform assignment |
| SA-Oracle-UAT | Database-OracleDB-svc_mon-oradb02 | *(blank)* | PolicyID is absent — account has no platform assignment |

---

### NS-S01 — Safe Name Does Not Match Pattern

> **Rule**: Safe name must match `{AccountType}-{Technology}-{Environment}` (e.g., `SA-Linux-Prod`).
> **Severity**: High

| Safe | Violation |
|------|-----------|
| ServiceAccts_Windows | Does not follow `{AccountType}-{Technology}-{Environment}` pattern — delimiter is underscore, not hyphen; no recognized AccountType segment |
| LinuxProd | Missing hyphen delimiter; cannot parse segments — no AccountType, Technology, or Environment identifiable |

---

## Medium Severity Findings

### NS-P01 — Platform Does Not Match Safe Technology

> **Rule**: PolicyID must be a valid platform for the safe's Technology segment (e.g., safes with Technology `Linux` must use `LinuxSSH` or `LinuxSSHKeys`).
> **Severity**: Medium

| Safe | Account | Current Platform | Expected Platform(s) | Violation |
|------|---------|-----------------|---------------------|-----------|
| SA-Linux-Prod | Operating System-WinServ-svc_app02-server04 | WinServerLocal | LinuxSSH, LinuxSSHKeys | Platform `WinServerLocal` is a Windows platform; safe Technology segment is `Linux` |

---

### NS-A01 — Account Name Does Not Follow Defined Pattern

> **Rule**: Account object name must match `{PlatformCategory}-{PlatformID}-{UserName}-{Address}`.
> **Severity**: Medium

| Safe | Account | Violation |
|------|---------|-----------|
| SA-Windows-Prod | svc_webserver02 | Account name has one segment — cannot parse `{PlatformCategory}-{PlatformID}-{UserName}-{Address}` pattern |
| SA-Oracle-UAT | db-mon-oradb01 | Three segments found; expected four — Address segment missing |

---

## Low Severity Findings

### NS-A02 — UserName Segment Does Not Match UserName Property

> **Rule**: The `{UserName}` segment of the account object name should match the `UserName` property value.
> **Severity**: Low

| Safe | Account | Name Segment | UserName Property | Violation |
|------|---------|-------------|------------------|-----------|
| SA-Linux-Prod | Operating System-LinuxSSH-svc_appserver-server01 | `svc_appserver` | `svc_app_server` | Username segment uses underscore run-on; property uses additional underscore separator — minor inconsistency |
