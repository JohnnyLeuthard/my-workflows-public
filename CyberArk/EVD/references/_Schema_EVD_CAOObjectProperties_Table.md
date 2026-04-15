# CAObjectProperties — Known Property Names

> Source: _Schema_CAObjectProperties_Properties.csv
> Auto-read by AI when querying account metadata. Do not edit manually unless the source CSV has changed.
> Table structure and column definitions: [_Schema_EVD_CyberArk_DB.md](_Schema_EVD_CyberArk_DB.md#dbo.CAObjectProperties)

---

## Table Structure Reminder

`CAObjectProperties` is an **EAV (Entity-Attribute-Value)** table.  
Each row represents a single property for a single account.

To query specific properties, always filter on:
`CAOPObjectPropertyName`

---

## Join Pattern

```sql
SELECT
    f.CAFFileName,
    f.CAFSafeName,
    op.CAOPObjectPropertyValue
FROM dbo.CAFiles f
JOIN dbo.CAObjectProperties op
    ON op.CAOPFileID = CAST(f.CAFFileID AS int)
    AND op.CAOPSafeID = f.CAFSafeID
WHERE op.CAOPObjectPropertyName = 'Address'
    AND f.CAFType = 2
    AND f.CAFDeletionDate IS NULL
```

---

# Known Property Names

## PSM / Session Recording

| Property Name | Notes |
|--------------|------|
| _PSMLiveSessions_1 | Live session slot 1 |
| _PSMLiveSessions_2 | Live session slot 2 |
| _PSMLiveSessions_3 | Live session slot 3 |
| _PSMLiveSessions_4 | Live session slot 4 |
| _PSMLiveSessions_5 | Live session slot 5 |
| ActualRecordings | Recording count |
| ConnectionComponentID | PSM connection component used |
| ConnectionType | Type of PSM connection |
| ExpectedRecordingsList | Expected recordings for the session |
| PSMClientApp | Client application used in session |
| PSMEndTime | Session end time |
| PSMPasswordID | Password ID used in session |
| PSMProtocol | Protocol used (RDP, SSH, etc.) |
| PSMRecordingEntity | Entity that recorded the session |
| PSMRemoteMachine | Target machine for PSM session |
| PSMSafeID | Safe ID for the PSM session |
| PSMSourceAddress | Source IP of PSM session |
| PSMStartTime | Session start time |
| PSMStatus | Status of PSM session |
| PSMVaultUserName | Vault username used in session |
| RecordingUploadError | Error detail if recording upload failed |
| ReportDuration | Duration reported for session |
| ReportFailureReason | Reason for report failure |
| ReportNumberOfRecords | Number of records in report |

## Account Identity & Platform

| Property Name | Notes |
|--------------|------|
| Address | Target address / hostname / IP |
| AppPoolName | IIS application pool name |
| ConfigurationSchemaVersion | Platform config schema version |
| Database | Database name |
| DeviceType | Device classification |
| FilePath | File path on target system |
| GroupName | Group associated with account |
| Location | Vault location |
| LogonDomain | Domain used for logon |
| PolicyID | Platform policy ID |
| Port | Target port |
| ProviderID | Internal CPM provider identifier |
| ServiceName | Windows service name |
| TableName | Database table name |
| UniqueIDColumnName | Unique ID column (DB accounts) |
| UniqueIDColumnValue | Unique ID value |
| UsageDisplayName | Display name |
| UserDN | LDAP distinguished name |
| UserName | Username |
| XMLAttribute | XML attribute |
| XMLElement | XML element |

## CPM / Password Management

| Property Name | Notes |
|--------------|------|
| ColumnName | Column name (DB accounts) |
| CPMDisabled | Whether CPM is disabled — see [eva_query_paterns.md](eva_query_paterns.md#boolean-style-properties-eg-cpmdisabled) |
| CPMErrorDetails | Details of last CPM error |
| CPMStatus | Current CPM status |
| CreationMethod | How account was created |
| EntityVersion | Account entity version |
| InProcess | CPM currently processing |
| LastFailDate | Last failure date — see [datetime_handling.md](datetime_handling.md) |
| LastPlatformTimeToHandle | Last platform handling time |
| LastSuccessChange | Last password change — see [datetime_handling.md](datetime_handling.md) |
| LastSuccessReconciliation | Last reconciliation — see [datetime_handling.md](datetime_handling.md) |
| LastSuccessVerification | Last verification — see [datetime_handling.md](datetime_handling.md) |
| LastTask | Last CPM task executed |
| MinValidityProcessed | Minimum validity processed |
| NextPeriodicChangeSearch | Next change search date — see [datetime_handling.md](datetime_handling.md) |
| NextPeriodicVerifySearch | Next verify search date — see [datetime_handling.md](datetime_handling.md) |
| PasswordRegex | Password validation regex |
| ResetImmediately | Reset password immediately |
| ResetImmediatelyReason | Reason for immediate reset |
| RestartService | Restart service after change |
| RetriesCount | Number of CPM retries |

## Linked / Extra Accounts

| Property Name | Notes |
|--------------|------|
| ExtraPass1Folder | Folder for linked account 1 |
| ExtraPass1Name | Name of linked account 1 |
| ExtraPass1Safe | Safe for linked account 1 |
| ExtraPass2Folder | Folder for linked account 2 |
| ExtraPass2Name | Name of linked account 2 |
| ExtraPass2Safe | Safe for linked account 2 |
| ExtraPass3Folder | Folder for linked account 3 |
| ExtraPass3Name | Name of linked account 3 |
| ExtraPass3Safe | Safe for linked account 3 |
| MasterPassFolder | Folder for reconcile account |
| MasterPassName | Name of reconcile account |
| ReconcileIsWinAccount | Is Windows account |

## Task Scheduling

| Property Name | Notes |
|--------------|------|
| TaskAutoGenerated | Auto-generated task |
| TaskDefinitionId | Task definition ID |
| TaskEndDate | Task end date |
| TaskFailureReason | Failure reason |
| TaskFolder | Task folder |
| TaskImmediate | Runs immediately |
| TaskInterval | Recurrence interval |
| TaskLastRunDate | Last run date |
| TaskName | Task name |
| TaskNextScheduleDate | Next run date |
| TaskOutputFileName | Output file |
| TaskScheduleDays | Scheduled days |
| TaskScheduleType | Schedule type |
| TaskSchedulingData1 | Extra scheduling data |
| TaskStartTime | Start time |
| TaskStatus | Status |
| TaskSubtype | Subtype |
| TaskType | Type |
| TaskUsername | Run-as username |

## SNMP

| Property Name | Notes |
|--------------|------|
| SNMPv3-AuthProtocol | Auth protocol |
| SNMPv3-Context | Context |
| SNMPv3-PrivacyProtocol | Privacy protocol |
| SNMPv3-SecurityLevel | Security level |

## Workflow / Custom Metadata (WF-)

| Property Name | Notes |
|--------------|------|
| WF-AccountOwner | Account owner |
| WF-Application | Application name |
| WF-ApplicationID | Application ID |
| WF-BusinessLanguage | Business description |
| WF-DatabaseType | Database type |
| WF-DBName | Database name |
| WF-DBServer | Database server |
| WF-Description | Description |
| WF-Notes | Notes |
| WF-ServiceAccount-ID | Service account ID |
| WF-Technology | Technology type |

## Miscellaneous

| Property Name | Notes |
|--------------|------|
| IncidentDetails | Incident details |
| LastNotifiedLockDate | Last lock notification |
| LastNotifiedModifyDate | Last modify notification |
| LimitDomainAccess | Domain access limited |
| OwnerName | Account owner |
| RiskScore | Risk score |
| SequenceID | Sequence ID |
| SupportGroupName | Support group |
| TicketID | Ticket/change ID |
