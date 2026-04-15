# Confirmations List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CAConfirmations`
> **Export File**: `ConfirmationsList.txt`
> **Vendor Docs**: [Confirmations List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/confirmations-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains the confirmation (approval/rejection) actions taken on access requests. Each row represents one confirmer's action on a specific request. Links to the Requests table via RequestID.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | RequestID | CACRequestID | ID of the request being confirmed |
| 2 | SafeID | CACSafeID | ID of the Safe the request is for |
| 3 | SafeName | CACSafeName | Name of the Safe |
| 4 | UserID | CACUserID | ID of the confirming user |
| 5 | UserName | CACUserName | Name of the confirming user |
| 6 | GroupID | CACGroupID | ID of the group the confirmer belongs to (if applicable) |
| 7 | GroupName | CACGroupName | Name of the confirmer's group |
| 8 | Reason | CACReason | Reason provided by the confirmer |
| 9 | Action | CACAction | Confirmation action taken (decode via CATextCodes Type 9) |
| 10 | ActionDate | CACActionDate | Date/time the action was taken |
| 11 | VaultID | CACVaultID | Vault instance identifier |

---

## Common Confirmation Actions (CATextCodes Type 9)

| Code | Action |
|------|--------|
| 1 | Approved |
| 2 | Rejected |

> Verify exact codes against your `CATextCodes` table.

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CARequests | CACRequestID → CARRequestID | The request being confirmed |
| CASafes | CACSafeID → CASSafeID | The target Safe |
| CAUsers | CACUserID → CAUserID | The confirming user |
| CAGroups | CACGroupID → CAGGroupID | The confirmer's group |

---

## Usage Notes

- Multiple confirmation rows may exist per request (one per confirmer)
- `GroupID`/`GroupName` indicates the group through which the confirmer has authorization
- Useful for audit trails showing who approved/rejected access and when
