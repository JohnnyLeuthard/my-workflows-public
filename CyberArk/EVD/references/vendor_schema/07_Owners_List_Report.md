# Owners List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CAOwners`
> **Export File**: `OwnersList.txt`
> **Vendor Docs**: [Owners List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/owners-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains a list of all Safe members (owners) and their permissions on each Safe. Each row represents one user's or group's membership and permission set on a specific Safe. This is the primary table for understanding who has access to what.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | SafeID | CAOSafeID | ID of the Safe |
| 2 | SafeName | CAOSafeName | Name of the Safe |
| 3 | OwnerID | CAOOwnerID | ID of the owner (user or group) |
| 4 | OwnerName | CAOOwnerName | Name of the owner |
| 5 | IsGroup | CAOIsGroup | Whether the owner is a group (`Yes`/`No`) |
| 6 | ReadAccount | CAOReadAccount | Can read/view account details (`Yes`/`No`) |
| 7 | UseAccount | CAOUseAccount | Can use (connect through) the account (`Yes`/`No`) |
| 8 | RetrieveAccount | CAORetrieveAccount | Can retrieve/copy the password (`Yes`/`No`) |
| 9 | ListContent | CAOListContent | Can list Safe contents (`Yes`/`No`) |
| 10 | AddAccount | CAOAddAccount | Can add accounts to the Safe (`Yes`/`No`) |
| 11 | UpdateAccountContent | CAOUpdateAccountContent | Can update account content (`Yes`/`No`) |
| 12 | UpdateAccountProperties | CAOUpdateAccountProperties | Can update account properties (`Yes`/`No`) |
| 13 | RenameAccount | CAORenameAccount | Can rename accounts (`Yes`/`No`) |
| 14 | DeleteAccount | CAODeleteAccount | Can delete accounts (`Yes`/`No`) |
| 15 | UnlockAccount | CAOUnlockAccount | Can unlock accounts (`Yes`/`No`) |
| 16 | ManageSafe | CAOManageSafe | Can manage Safe properties (`Yes`/`No`) |
| 17 | ManageSafeMembers | CAOManageSafeMembers | Can add/remove Safe members (`Yes`/`No`) |
| 18 | ViewAuditLog | CAOViewAuditLog | Can view Safe audit log (`Yes`/`No`) |
| 19 | ViewSafeMembers | CAOViewSafeMembers | Can view Safe members list (`Yes`/`No`) |
| 20 | BackupSafe | CAOBackupSafe | Can back up the Safe (`Yes`/`No`) |
| 21 | RequestsAuthorizationLevel | CAORequestsAuthorizationLevel | Authorization level for access requests (0, 1, or 2) |
| 22 | AccessNoConfirmation | CAOAccessNoConfirmation | Can access without confirmation (`Yes`/`No`) |
| 23 | CreateFolder | CAOCreateFolder | Can create folders in the Safe (`Yes`/`No`) |
| 24 | DeleteFolder | CAODeleteFolder | Can delete folders (`Yes`/`No`) |
| 25 | MoveAccountsAndFolders | CAOMoveAccountsAndFolders | Can move accounts and folders (`Yes`/`No`) |
| 26 | InitiateCPMChange | CAOInitiateCPMChange | Can initiate CPM password change (`Yes`/`No`) |
| 27 | InitiateCPMChangeWithManualPassword | CAOInitiateCPMChangeWithManualPassword | Can initiate change with manual password (`Yes`/`No`) |
| 28 | SpecifyNextAccountContent | CAOSpecifyNextAccountContent | Can specify the next password value (`Yes`/`No`) |
| 29 | VaultID | CAOVaultID | Vault instance identifier |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CASafes | CAOSafeID → CASSafeID | The Safe being owned |
| CAUsers | CAOOwnerID → CAUserID | The owner user (when IsGroup = No) |
| CAGroups | CAOOwnerID → CAGGroupID | The owner group (when IsGroup = Yes) |

---

## Usage Notes

- This table is critical for access reviews and compliance reporting
- Built-in owners (e.g., `PasswordManagerUser`, `PVWAGWUser`) appear on most Safes
- `RequestsAuthorizationLevel`: `0` = no authorization, `1` = authorize level 1, `2` = authorize level 2
- The Owners table does NOT exist in your environment-specific schema file — confirm if it was excluded from the EVD SQL import or if it uses a different table name
