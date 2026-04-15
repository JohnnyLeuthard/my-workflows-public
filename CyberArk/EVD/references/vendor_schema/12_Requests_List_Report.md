# Requests List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CARequests`
> **Export File**: `RequestsList.txt`
> **Vendor Docs**: [Requests List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/requests-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains all access requests made by users for privileged accounts in Safes that require dual-control approval. Each row represents a single access request with its current status.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | RequestID | CARRequestID | Unique request identifier |
| 2 | UserID | CARUserID | ID of the user who made the request |
| 3 | UserName | CARUserName | Name of the requesting user |
| 4 | Type | CARType | Request type (decode via CATextCodes Type 7) |
| 5 | SafeID | CARSafeID | ID of the Safe being requested |
| 6 | SafeName | CARSafeName | Name of the Safe |
| 7 | FolderName | CARFolderName | Folder within the Safe |
| 8 | FileID | CARFileID | ID of the specific file/account requested |
| 9 | FileName | CARFileName | Name of the file/account |
| 10 | Reason | CARReason | User-provided reason for the request |
| 11 | AccessType | CARAccessType | Type of access requested |
| 12 | ConfirmationsCount | CARConfirmationsCount | Total confirmations received |
| 13 | ConfirmationsLeft | CARConfirmationsLeft | Remaining confirmations needed |
| 14 | RejectionsCount | CARRejectionsCount | Number of rejections received |
| 15 | InvalidReason | CARInvalidReason | Reason code if request was invalidated |
| 16 | CreationDate | CARCreationDate | Date/time the request was created |
| 17 | ExpirationDate | CARExpirationDate | Date/time the request expires |
| 18 | PeriodFrom | CARPeriodFrom | Start of the requested access period |
| 19 | PeriodTo | CARPeriodTo | End of the requested access period |
| 20 | LastUsedDate | CARLastUsedDate | Date/time the granted access was last used |
| 21 | Status | CARStatus | Request status (decode via CATextCodes Type 8) |
| 22 | VaultID | CARVaultID | Vault instance identifier |

---

## Common Request Statuses (CATextCodes Type 8)

| Code | Status |
|------|--------|
| 1 | Pending |
| 2 | Approved |
| 3 | Rejected |
| 4 | Expired |
| 5 | Used |

> Verify exact codes against your `CATextCodes` table.

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CAUsers | CARUserID → CAUserID | Requesting user |
| CASafes | CARSafeID → CASSafeID | Target Safe |
| CAFiles | CARFileID → CAFFileID | Target file/account |
| CAConfirmations | CACRequestID → CARRequestID | Confirmations for this request |

---

## Usage Notes

- Requests only exist for Safes with dual-control enabled (`CASConfirmersCount > 0`)
- `ConfirmationsLeft = 0` with `Status = Approved` means all required approvals received
- Useful for compliance reporting on access approval workflows
