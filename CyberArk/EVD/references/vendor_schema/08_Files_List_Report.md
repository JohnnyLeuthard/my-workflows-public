# Files List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CAFiles`
> **Export File**: `FilesList.txt`
> **Vendor Docs**: [Files List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/files-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains a list of all files and password objects stored in Vault Safes. Each row represents a single file or account object. This is the core account inventory table — most account queries start here.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | SafeID | CAFSafeID | ID of the Safe containing this file |
| 2 | SafeName | CAFSafeName | Name of the containing Safe |
| 3 | Folder | CAFFolder | Folder path within the Safe (typically `Root`) |
| 4 | FileID | CAFFileID | Unique numeric identifier for the file/account |
| 5 | FileName | CAFFileName | Name of the file/account object |
| 6 | InternalName | CAFInternalName | Internal Vault name for the file |
| 7 | Size | CAFSize | File size in bytes |
| 8 | CreatedBy | CAFCreatedBy | User who created the file |
| 9 | CreationDate | CAFCreationDate | Date/time the file was created |
| 10 | LastUsedBy | CAFLastUsedBy | Last user to access the file |
| 11 | LastUsedDate | CAFLastUsedDate | Date/time of last access |
| 12 | ModificationDate | CAFModificationDate | Date/time of last modification |
| 13 | ModifiedBy | CAFModifiedBy | User who last modified the file |
| 14 | DeletedBy | CAFDeletedBy | User who deleted the file (NULL if not deleted) |
| 15 | DeletionDate | CAFDeletionDate | Date/time the file was deleted (NULL if not deleted) |
| 16 | LockDate | CAFLockDate | Date/time the file was locked |
| 17 | LockBy | CAFLockBy | User who locked the file |
| 18 | LockByID | CAFLockByID | User ID of the locker |
| 19 | Accessed | CAFAccessed | Whether the file has been accessed (`Yes`/`No`) |
| 20 | New | CAFNew | Whether the file is new/unread (`Yes`/`No`) |
| 21 | Retrieved | CAFRetrieved | Whether the file has been retrieved (`Yes`/`No`) |
| 22 | Modified | CAFModified | Whether the file has been modified (`Yes`/`No`) |
| 23 | IsRequestNeeded | CAFIsRequestNeeded | Whether an access request is needed (`Yes`/`No`) |
| 24 | ValidationStatus | CAFValidationStatus | Content validation status |
| 25 | Type | CAFType | File type: `2` = Password, `1` = File, other = system objects |
| 26 | CompressedSize | CAFCompressedSize | Compressed file size in bytes |
| 27 | LastModifiedDate | CAFLastModifiedDate | Last modification date (may differ from ModificationDate for CPM changes) |
| 28 | LastModifiedBy | CAFLastModifiedBy | Last modifier (may differ from ModifiedBy) |
| 29 | LastUsedByHuman | CAFLastUsedByHuman | Last human user to access (excludes CPM/system accounts) |
| 30 | LastUsedHumanDate | CAFLastUsedHumanDate | Date of last human access |
| 31 | LastUsedByComponent | CAFLastUsedByComponent | Last component (CPM, PSM, etc.) to access |
| 32 | LastUsedComponentDate | CAFLastUsedComponentDate | Date of last component access |
| 33 | VaultID | CAFVaultID | Vault instance identifier |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CASafes | CAFSafeID → CASSafeID | The containing Safe |
| CAObjectProperties | CAOPFileID → CAFFileID AND CAOPSafeID → CAFSafeID | Account properties (EAV) |
| CARequests | CARFileID → CAFFileID | Access requests for this file |

---

## Usage Notes

- **CAFType = 2** filters to password/account objects (most common query filter)
- **CAFDeletionDate IS NULL** filters to active (non-deleted) accounts
- `FileName` is typically the account object name (e.g., `Operating System-WinDomain-myserver.com-admin`)
- To get account metadata (Address, UserName, Platform, etc.), join to `CAObjectProperties`
- `LastUsedByHuman` vs `LastUsedByComponent` distinguishes human access from automated CPM/PSM activity

```sql
-- Common pattern: active accounts with their address and username
SELECT
    f.CAFFileName,
    f.CAFSafeName,
    addr.CAOPObjectPropertyValue AS Address,
    uname.CAOPObjectPropertyValue AS UserName
FROM dbo.CAFiles f
LEFT JOIN dbo.CAObjectProperties addr
    ON addr.CAOPFileID = CAST(f.CAFFileID AS int)
    AND addr.CAOPSafeID = f.CAFSafeID
    AND addr.CAOPObjectPropertyName = 'Address'
LEFT JOIN dbo.CAObjectProperties uname
    ON uname.CAOPFileID = CAST(f.CAFFileID AS int)
    AND uname.CAOPSafeID = f.CAFSafeID
    AND uname.CAOPObjectPropertyName = 'UserName'
WHERE f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
```
