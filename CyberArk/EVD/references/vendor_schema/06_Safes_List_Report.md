# Safes List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CASafes`
> **Export File**: `SafesList.txt`
> **Vendor Docs**: [Safes List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/safes-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains a list of all Safes in the Vault and their Safe properties. Safes are the primary containers for storing privileged account objects (passwords, keys, files).

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | SafeID | CASSafeID | Unique numeric identifier for the Safe |
| 2 | SafeName | CASSafeName | Name of the Safe |
| 3 | LocationID | CASLocationID | ID of the Safe's location in the Vault hierarchy |
| 4 | LocationName | CASLocationName | Full path of the Safe's location |
| 5 | Size | CASSize | Total size allocated to the Safe (bytes) |
| 6 | MaxSize | CASMaxSize | Maximum size allowed for the Safe (bytes) |
| 7 | UsedSize | CASUsedSize | Current used size (bytes) |
| 8 | LastUsed | CASLastUsed | Date/time the Safe was last accessed |
| 9 | VirusFree | CASVirusFree | Whether the Safe is marked virus-free (`Yes`/`No`) |
| 10 | TextOnly | CASTextOnly | Whether the Safe stores text-only content (`Yes`/`No`) |
| 11 | AccessLocation | CASAccessLocation | Access location restrictions (decode via CATextCodes Type 6) |
| 12 | SecurityLevel | CASSecurityLevel | Security level of the Safe |
| 13 | Delay | CASDelay | Access delay in minutes before retrieval is allowed |
| 14 | FromHour | CASFromHour | Start of allowed access hours (0–23) |
| 15 | ToHour | CASToHour | End of allowed access hours (0–23) |
| 16 | DailyVersions | CASDailyVersions | Number of daily versions to retain |
| 17 | MonthlyVersions | CASMonthlyVersions | Number of monthly versions to retain |
| 18 | YearlyVersions | CASYearlyVersions | Number of yearly versions to retain |
| 19 | LogRetentionPeriod | CASLogRetentionPeriod | Days to retain Safe activity logs |
| 20 | ObjectsRetentionPeriod | CASObjectsRetentionPeriod | Days to retain deleted objects |
| 21 | RequestsRetentionPeriod | CASRequestsRetentionPeriod | Days to retain access requests |
| 22 | ShareOptions | CASShareOptions | Safe sharing options |
| 23 | ConfirmersCount | CASConfirmersCount | Number of confirmers required for dual-control |
| 24 | ConfirmType | CASConfirmType | Type of confirmation required |
| 25 | DefaultAccessMarks | CASDefaultAccessMarks | Default access marks for objects in this Safe |
| 26 | DefaultFileCompression | CASDefaultFileCompression | Default file compression setting (`Yes`/`No`) |
| 27 | DefaultReadOnly | CASDefaultReadOnly | Whether objects default to read-only (`Yes`/`No`) |
| 28 | QuotaOwner | CASQuotaOwner | User whose quota is charged for this Safe |
| 29 | UseFileCategories | CASUseFileCategories | Whether file categories are enabled (`Yes`/`No`) |
| 30 | RequireReasonToRetrieve | CASRequireReasonToRetrieve | Whether a reason is required to retrieve passwords (`Yes`/`No`) |
| 31 | EnforceExclusivePasswords | CASEnforceExclusivePasswords | Whether exclusive password access is enforced (`Yes`/`No`) |
| 32 | RequireContentValidation | CASRequireContentValidation | Whether content validation is required (`Yes`/`No`) |
| 33 | CreationDate | CASCreationDate | Date the Safe was created |
| 34 | CreatedBy | CASCreatedBy | User who created the Safe |
| 35 | NumberOfPasswordVersions | CASNumberOfPasswordVersions | Number of password versions to retain |
| 36 | VaultID | CASVaultID | Vault instance identifier |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CALocations | CASLocationID → CALocationID | Safe's location |
| CAFiles | CAFSafeID → CASSafeID | Files/accounts stored in this Safe |
| CAObjectProperties | CAOPSafeID → CASSafeID | Properties of objects in this Safe |
| CAOwners | CAOSafeID → CASSafeID | Safe owners/members |
| CARequests | CARSafeID → CASSafeID | Access requests for this Safe |
| CAConfirmations | CACSafeID → CASSafeID | Confirmations for this Safe |
| CALog | CAASafeID → CASSafeID | Activity log for this Safe |
| CAEvents | CAESafe → CASSafeName | Events for this Safe (joined on name) |

---

## Usage Notes

- System Safes (e.g., `System`, `VaultInternal`, `PasswordManager`, `PasswordManagerShared`, `PVWAConfig`, `Notification Engine`) are included
- `ConfirmersCount > 0` indicates dual-control is enabled
- `Delay > 0` indicates a time-delayed access policy
