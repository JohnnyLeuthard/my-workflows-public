# EVD CyberArk Database Schema

> **Environment-specific** — Column lengths and types have been modified from vendor defaults to match our environment.
> For out-of-box vendor schema (column descriptions, lookup codes, relationships), see [`vendor_schema/_INDEX.md`](vendor_schema/_INDEX.md).
> See also: [_Schema_EVD_CAOObjectProperties_Table.md](_Schema_EVD_CAOObjectProperties_Table.md) for the EAV property table detail.

## Key Relationships

| Parent Table | Key Column | Child Table | Foreign Key |
|---|---|---|---|
| CASafes | CASSafeID | CAFiles | CAFSafeID |
| CASafes | CASSafeID | CAObjectProperties | CAOPSafeID |
| CASafes | CASSafeID | CARequests | CARSafeID |
| CASafes | CASSafeID | CAConfirmations | CACSafeID |
| CASafes | CASSafeID | CALog | CAASafeID |
| CAFiles | CAFFileID | CAObjectProperties | CAOPFileID |
| CAFiles | CAFFileID | CARequests | CARFileID |
| CAUsers | CAUserID | CALog | CAAUserID |
| CAUsers | CAUserID | CARequests | CARUserID |
| CAUsers | CAUserID | CAConfirmations | CACUserID |
| CAUsers | CAUserID | CAGroupMembers | CAGMUserID |
| CAGroups | CAGGroupID | CAGroupMembers | CAGMGroupID |
| CAGroups | CAGGroupID | CAConfirmations | CACGroupID |
| CALocations | CALocationID | CAUsers | CALocationID |
| CALocations | CALocationID | CASafes | CASLocationID |
| CALocations | CALocationID | CAGroups | CAGLocationID |

---

## dbo.CAObjectProperties

> **EAV table** — one row per property per account. See [_Schema_EVD_CAOObjectProperties_Table.md](_Schema_EVD_CAOObjectProperties_Table.md) for known property names and join patterns.

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CAOPSafeID | bigint |  | Yes |
| 2 | CAOPFileID | int |  | Yes |
| 3 | CAOPObjectPropertyName | nvarchar | 256 | Yes |
| 4 | CAOPObjectPropertyValue | nvarchar | 4000 | Yes |
| 5 | CAOPVaultID | nvarchar | 56 | Yes |

> ⚠ Column lengths above are inferred from the join pattern — update with actual export when available.

---

## dbo.CAUsers

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CAUserID | bigint |  | Yes |
| 2 | CAUserName | nvarchar | 256 | Yes |
| 3 | CALocationID | bigint |  | Yes |
| 4 | CALocationName | nvarchar | 256 | Yes |
| 5 | CAUFirstName | nvarchar | 600 | Yes |
| 6 | CAULastName | nvarchar | 600 | Yes |
| 7 | CAUBusinessEmail | nvarchar | 1000 | Yes |
| 8 | CAUDisabled | nvarchar | 10 | Yes |
| 9 | CAUFromHour | int |  | Yes |
| 10 | CAUToHour | int |  | Yes |
| 11 | CAUExpirationDate | datetime |  | Yes |
| 12 | CAUPasswordNeverExpires | nvarchar | 10 | Yes |
| 13 | CAULogRetentionPeriod | int |  | Yes |
| 14 | CAUAuthenticationMethods | int |  | Yes |
| 15 | CAUAuthorizations | int |  | Yes |
| 16 | CAUGatewayAccountAuthorizations | int |  | Yes |
| 17 | CAUDistinguishedName | nvarchar | 1024 | Yes |
| 18 | CAUExternalInternal | int |  | Yes |
| 19 | CAULDAPFullDN | nvarchar | 2048 | Yes |
| 20 | CAULDAPDirectory | nvarchar | 512 | Yes |
| 21 | CAUMapName | nvarchar | 256 | Yes |
| 22 | CAUMapID | bigint |  | Yes |
| 23 | CAULastLogonDate | datetime |  | Yes |
| 24 | CAUPrevLogonDate | datetime |  | Yes |
| 25 | CAUserTypeID | int |  | Yes |
| 26 | CAURestrictedInterfaces | nvarchar | 2048 | Yes |
| 27 | CAUApplicationMetadata | nvarchar | 8000 | Yes |
| 28 | CAUCreationDate | datetime |  | Yes |
| 29 | CAUVaultID | nvarchar | 56 | Yes |

---

## dbo.CASafes

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CASSafeID | bigint |  | Yes |
| 2 | CASSafeName | nvarchar | 56 | Yes |
| 3 | CASLocationID | bigint |  | Yes |
| 4 | CASLocationName | nvarchar | 256 | Yes |
| 5 | CASSize | bigint |  | Yes |
| 6 | CASMaxSize | bigint |  | Yes |
| 7 | CASUsedSize | int |  | Yes |
| 8 | CASLastUsed | datetime |  | Yes |
| 9 | CASVirusFree | nvarchar | 10 | Yes |
| 10 | CASTextOnly | nvarchar | 10 | Yes |
| 11 | CASAccessLocation | int |  | Yes |
| 12 | CASSecurityLevel | int |  | Yes |
| 13 | CASDelay | int |  | Yes |
| 14 | CASFromHour | int |  | Yes |
| 15 | CASToHour | int |  | Yes |
| 16 | CASDailyVersions | int |  | Yes |
| 17 | CASMonthlyVersions | int |  | Yes |
| 18 | CASYearlyVersions | int |  | Yes |
| 19 | CASLogRetentionPeriod | int |  | Yes |
| 20 | CASObjectsRetentionPeriod | int |  | Yes |
| 21 | CASRequestsRetentionPeriod | int |  | Yes |
| 22 | CASShareOptions | int |  | Yes |
| 23 | CASConfirmersCount | int |  | Yes |
| 24 | CASConfirmType | int |  | Yes |
| 25 | CASDefaultAccessMarks | int |  | Yes |
| 26 | CASDefaultFileCompression | nvarchar | 10 | Yes |
| 27 | CASDefaultReadOnly | nvarchar | 10 | Yes |
| 28 | CASQuotaOwner | nvarchar | 256 | Yes |
| 29 | CASUseFileCategories | nvarchar | 10 | Yes |
| 30 | CASRequireReasonToRetrieve | nvarchar | 10 | Yes |
| 31 | CASEnforceExclusivePasswords | nvarchar | 10 | Yes |
| 32 | CASRequireContentValidation | nvarchar | 10 | Yes |
| 33 | CASCreationDate | datetime |  | Yes |
| 34 | CASCreatedBy | nvarchar | 1026 | Yes |
| 35 | CASNumberOfPasswordVersions | int |  | Yes |
| 36 | CASVaultID | nvarchar | 56 | Yes |

---

## dbo.CARequests

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CARRequestID | int |  | Yes |
| 2 | CARUserID | bigint |  | Yes |
| 3 | CARUserName | nvarchar | 256 | Yes |
| 4 | CARType | int |  | Yes |
| 5 | CARSafeID | bigint |  | Yes |
| 6 | CARSafeName | nvarchar | 56 | Yes |
| 7 | CARFolderName | nvarchar | 340 | Yes |
| 8 | CARFileID | bigint |  | Yes |
| 9 | CARFileName | nvarchar | 340 | Yes |
| 10 | CARReason | nvarchar | 400 | Yes |
| 11 | CARAccessType | int |  | Yes |
| 12 | CARConfirmationsCount | int |  | Yes |
| 13 | CARConfirmationsLeft | int |  | Yes |
| 14 | CARRejectionsCount | int |  | Yes |
| 15 | CARInvalidReason | int |  | Yes |
| 16 | CARCreationDate | datetime |  | Yes |
| 17 | CARExpirationDate | datetime |  | Yes |
| 18 | CARPeriodFrom | datetime |  | Yes |
| 19 | CARPeriodTo | datetime |  | Yes |
| 20 | CARLastUsedDate | datetime |  | Yes |
| 21 | CARStatus | int |  | Yes |
| 22 | CARVaultID | nvarchar | 56 | Yes |

---

## dbo.CAEvents

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CAESafe | nvarchar | 56 | Yes |
| 2 | CAEEventID | bigint |  | Yes |
| 3 | CAESourceID | int |  | Yes |
| 4 | CAEEventTypeID | int |  | Yes |
| 5 | CAEClientID | nvarchar | 20 | Yes |
| 6 | CAEUser | nvarchar | 256 | Yes |
| 7 | CAEAgent | nvarchar | 256 | Yes |
| 8 | CAEFromIP | nvarchar | 30 | Yes |
| 9 | CAEVersion | nvarchar | 30 | Yes |
| 10 | CAECreationDate | datetime |  | Yes |
| 11 | CAEExpirationDate | datetime |  | Yes |
| 12 | CAEEventVersion | int |  | Yes |
| 13 | CAEData | nvarchar | 8000 | Yes |
| 14 | CAEVaultID | nvarchar | 56 | Yes |

---

## dbo.CAFiles

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CAFSafeID | bigint |  | Yes |
| 2 | CAFSafeName | nvarchar | 56 | Yes |
| 3 | CAFFolder | nvarchar | 340 | Yes |
| 4 | CAFFileID | bigint |  | Yes |
| 5 | CAFFileName | nvarchar | 340 | No |
| 6 | CAFInternalName | nvarchar | 56 | Yes |
| 7 | CAFSize | bigint |  | Yes |
| 8 | CAFCreatedBy | nvarchar | 256 | Yes |
| 9 | CAFCreationDate | datetime |  | Yes |
| 10 | CAFLastUsedBy | nvarchar | 256 | Yes |
| 11 | CAFLastUsedDate | datetime |  | Yes |
| 12 | CAFModificationDate | datetime |  | Yes |
| 13 | CAFModifiedBy | nvarchar | 256 | Yes |
| 14 | CAFDeletedBy | nvarchar | 256 | Yes |
| 15 | CAFDeletionDate | datetime |  | Yes |
| 16 | CAFLockDate | datetime |  | Yes |
| 17 | CAFLockBy | nvarchar | 256 | Yes |
| 18 | CAFLockByID | bigint |  | Yes |
| 19 | CAFAccessed | nvarchar | 10 | Yes |
| 20 | CAFNew | nvarchar | 10 | Yes |
| 21 | CAFRetrieved | nvarchar | 10 | Yes |
| 22 | CAFModified | nvarchar | 10 | Yes |
| 23 | CAFIsRequestNeeded | nvarchar | 10 | Yes |
| 24 | CAFValidationStatus | int |  | Yes |
| 25 | CAFType | int |  | Yes |
| 26 | CAFCompressedSize | bigint |  | Yes |
| 27 | CAFLastModifiedDate | datetime |  | Yes |
| 28 | CAFLastModifiedBy | nvarchar | 1026 | Yes |
| 29 | CAFLastUsedByHuman | nvarchar | 1026 | Yes |
| 30 | CAFLastUsedHumanDate | datetime |  | Yes |
| 31 | CAFLastUsedByComponent | nvarchar | 1026 | Yes |
| 32 | CAFLastUsedComponentDate | datetime |  | Yes |
| 33 | CAFVaultID | nvarchar | 56 | Yes |

---

## dbo.CAConfirmations

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CACRequestID | int |  | Yes |
| 2 | CACSafeID | bigint |  | Yes |
| 3 | CACSafeName | nvarchar | 56 | Yes |
| 4 | CACUserID | bigint |  | Yes |
| 5 | CACUserName | nvarchar | 256 | Yes |
| 6 | CACGroupID | bigint |  | Yes |
| 7 | CACGroupName | nvarchar | 256 | Yes |
| 8 | CACReason | nvarchar | 340 | Yes |
| 9 | CACAction | int |  | Yes |
| 10 | CACActionDate | datetime |  | Yes |
| 11 | CACVaultID | nvarchar | 56 | Yes |

---

## dbo.CAGroupMembers

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CAGMGroupID | bigint |  | Yes |
| 2 | CAGMUserID | bigint |  | Yes |
| 3 | CAGMMemberIsGroup | nvarchar | 10 | Yes |
| 4 | CAGMVaultID | nvarchar | 56 | Yes |

---

## dbo.CAGroups

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CAGGroupID | bigint |  | Yes |
| 2 | CAGGroupName | nvarchar | 256 | Yes |
| 3 | CAGLocationID | bigint |  | Yes |
| 4 | CAGLocationName | nvarchar | 256 | Yes |
| 5 | CAGDescription | nvarchar | 1600 | Yes |
| 6 | CAGExternalGroupName | nvarchar | 256 | Yes |
| 7 | CAGExternalInternal | int |  | Yes |
| 8 | CAGLDAPFullDN | nvarchar | 2048 | Yes |
| 9 | CAGLDAPDirectory | nvarchar | 512 | Yes |
| 10 | CAGMapName | nvarchar | 256 | Yes |
| 11 | CAGMapID | bigint |  | Yes |
| 12 | CAGVaultID | nvarchar | 56 | Yes |

---

## dbo.CALocations

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CALocationID | bigint |  | Yes |
| 2 | CALocationName | nvarchar | 256 | Yes |
| 3 | CALVaultID | nvarchar | 56 | Yes |

---

## dbo.CALog

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CAAMasterID | bigint |  | Yes |
| 2 | CAAActivityID | bigint |  | Yes |
| 3 | CAAActivityType | int |  | Yes |
| 4 | CAAActivityCode | int |  | Yes |
| 5 | CAATime | datetime |  | Yes |
| 6 | CAAAction | nvarchar | MAX | Yes |
| 7 | CAASafeID | bigint |  | Yes |
| 8 | CAASafeName | nvarchar | 520 | Yes |
| 9 | CAAUserID | bigint |  | Yes |
| 10 | CAAUserName | nvarchar | 1200 | Yes |

---

## dbo.CATextCodes

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | CATCType | int |  | Yes |
| 2 | CATCCode | int |  | Yes |
| 3 | CATCText | nvarchar | 512 | Yes |

---

## app.DailyImport (Custom — not vendor)

| # | Column | DataType | Length | Nullable |
|---|--------|----------|--------|----------|
| 1 | Table | varchar | 50 | Yes |
| 2 | rowcount | int |  | Yes |
| 3 | completionTime | date |  | Yes |

---

## Known Gaps Between Environment and Vendor Schema

| Table | Status | Notes |
|---|---|---|
| CAOwners | NOT in environment DB | Present in vendor schema ([07_Owners_List_Report](vendor_schema/07_Owners_List_Report.md)). Contains Safe membership and permissions data. If queries require owner/permission data, confirm whether this table was excluded from the EVD SQL import or uses a different table name in this environment. |

