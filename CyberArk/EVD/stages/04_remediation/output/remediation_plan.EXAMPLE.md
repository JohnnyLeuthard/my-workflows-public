# Remediation Plan — EXAMPLE FILE

> **This is an example file, not real pipeline output.**
> It shows what `remediation_plan.md` looks like after Stage 4 runs.
> Findings below correspond to `stages/03_parsing/output/compliance_report.EXAMPLE.md`.

---

**Generated from**: `stages/03_parsing/output/compliance_report.EXAMPLE.md`
**Generated**: 2026-04-04

---

## Executive Summary

| Severity | Count | Impact |
|----------|-------|--------|
| High     | 4     | 2 accounts missing platform assignments; 2 safes with invalid names |
| Medium   | 3     | 1 account on the wrong platform; 2 accounts with malformed object names |
| Low      | 1     | 1 account with a minor username segment mismatch |

The most urgent items are the two accounts missing platform assignments (NS-P02) — unmanaged accounts cannot be picked up by CPM for automated password rotation, creating an uncontrolled credential exposure. The two non-conforming safe names (NS-S01) must be resolved manually via PVWA Administration; these cannot be automated through psPAS. The medium-severity platform mismatch and naming issues can be addressed after high-severity items are resolved.

---

## Priority 1 — High Severity

### NS-P02 — Assign Missing Platform IDs

Accounts with no platform assignment cannot be managed by CPM. Assign the appropriate platform before the next CPM cycle.

| Account | Safe | What Is Wrong | Correct Target | Action |
|---------|------|---------------|----------------|--------|
| Operating System-LinuxSSH-svc_backup-server03 | SA-Linux-Prod | PolicyID is blank | `LinuxSSH` (matches safe Technology segment `Linux`) | Set platform to `LinuxSSH` |
| Database-OracleDB-svc_mon-oradb02 | SA-Oracle-UAT | PolicyID is blank | `OracleDB` (matches safe Technology segment `Oracle`) | Set platform to `OracleDB` |

---

### NS-S01 — Rename Non-Conforming Safes

Safes must follow the `{AccountType}-{Technology}-{Environment}` pattern with hyphens as delimiters. Safe renames require PVWA Administration — they cannot be automated through psPAS.

| Safe | What Is Wrong | Correct Target | Action |
|------|---------------|----------------|--------|
| ServiceAccts_Windows | Uses underscores, missing AccountType/Environment segments | `SA-Windows-Prod` (or appropriate Environment) | Rename safe via PVWA Administration > Safes |
| LinuxProd | No delimiters; no recognizable segments | `SA-Linux-Prod` (or appropriate AccountType and Environment) | Rename safe via PVWA Administration > Safes |

> **Note**: Before renaming a safe, confirm there are no hard-coded safe name references in CPM policies, PSM connector configurations, or application integrations. A safe rename is the highest-risk operation in this plan.

---

## Priority 2 — Medium Severity

### NS-P01 — Fix Platform Mismatch

Account is in a Linux safe but assigned a Windows platform. This may cause CPM to apply the wrong rotation policy.

| Account | Safe | Current Platform | Correct Platform | Action |
|---------|------|-----------------|-----------------|--------|
| Operating System-WinServ-svc_app02-server04 | SA-Linux-Prod | WinServerLocal | `LinuxSSH` | Change platform via Set Account > Platform in PVWA, or use psPAS Set-PASAccount |

---

### NS-A01 — Fix Malformed Account Object Names

Account names must follow `{PlatformCategory}-{PlatformID}-{UserName}-{Address}`.

| Account | Safe | What Is Wrong | Correct Target | Action |
|---------|------|---------------|----------------|--------|
| svc_webserver02 | SA-Windows-Prod | Single segment — no structure | `Operating System-WinServerLocal-svc_webserver02-webserver02.domain.com` | Rename account object via PVWA or psPAS Set-PASAccount |
| db-mon-oradb01 | SA-Oracle-UAT | Three segments — missing Address | `Database-OracleDB-db_mon-oradb01.domain.com` | Rename account object and verify Address property |

---

## Priority 3 — Low Severity

### NS-A02 — Username Segment Inconsistency

Minor inconsistency between account object name segment and the UserName property value. Low risk but creates confusion during access reviews.

| Account | Safe | Name Segment | UserName Property | Action |
|---------|------|-------------|------------------|--------|
| Operating System-LinuxSSH-svc_appserver-server01 | SA-Linux-Prod | `svc_appserver` | `svc_app_server` | Align account object name segment with UserName property value, or update the UserName property to match the name |

---

## Automation Routing

| Finding Type | Rule IDs | psPAS Automatable? | Manual Action if Not |
|-------------|----------|--------------------|---------------------|
| Assign platform | NS-P02 | Yes — `Set-PASAccount -PlatformID` | Edit account in PVWA > Account Details > Platform |
| Fix platform mismatch | NS-P01 | Yes — `Set-PASAccount -PlatformID` | Edit account in PVWA > Account Details > Platform |
| Rename account object | NS-A01, NS-A02 | Yes — `Set-PASAccount -Name` | Rename account in PVWA > Account Details > Name |
| Rename safe | NS-S01 | **No — psPAS cannot rename safes** | PVWA Administration > Safes > Rename |

To automate the psPAS-eligible items (NS-P01, NS-P02, NS-A01, NS-A02), take this plan to `../../../psPAS/` and run Stage 01 Planning. Pass this file as the compliance input.

> **Safe renames (NS-S01) must be handled manually regardless.** Coordinate with the CyberArk admin team and schedule a maintenance window — a safe rename affects all components that reference the safe by name.

---

## Validation Queries

After completing remediation, run these EVD templates to confirm findings are resolved:

| After fixing... | Run this template | What to look for |
|----------------|-------------------|-----------------|
| NS-P02 (missing platforms) | **Platform Compliance** (`05_platform_compliance.md`) | Zero rows for the remediated accounts |
| NS-P01 (platform mismatch) | **Platform Compliance** (`05_platform_compliance.md`) | Remediated accounts should no longer appear |
| NS-S01 (safe name) | Re-run the original query against the new safe names | Confirm accounts are accessible under the renamed safe |
| NS-A01, NS-A02 (account names) | Re-run the original query | Confirm object names now parse correctly in Stage 3 |
