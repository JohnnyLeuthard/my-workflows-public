# EVD Vendor Schema Reference (Out-of-Box)

> **CyberArk PAM Self-Hosted 14.2**
> **Source**: [CyberArk EVD Output Values](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/output%20values.htm)
> **Status**: Created from training knowledge — verify each file against live vendor docs

These files document the **out-of-box** EVD schema as shipped by CyberArk. For your environment-specific schema (modified column lengths and types), see the parent `references/` directory:
- [_Schema_EVD_CyberArk_DB.md](../_Schema_EVD_CyberArk_DB.md) — Environment DB schema (all tables)
- [_Schema_EVD_CAOObjectProperties_Table.md](../_Schema_EVD_CAOObjectProperties_Table.md) — Known property names for the EAV table

---

## Report Schemas

| # | Report | DB Table | File |
|---|--------|----------|------|
| 1 | [Text Type Values](01_Text_Type_Values.md) | dbo.CATextCodes | Lookup/reference table |
| 2 | [Locations List Report](02_Locations_List_Report.md) | dbo.CALocations | LocationsList.txt |
| 3 | [Users List Report](03_Users_List_Report.md) | dbo.CAUsers | UsersList.txt |
| 4 | [Groups List Report](04_Groups_List_Report.md) | dbo.CAGroups | GroupsList.txt |
| 5 | [Group Members List Report](05_Group_Members_List_Report.md) | dbo.CAGroupMembers | GroupMembersList.txt |
| 6 | [Safes List Report](06_Safes_List_Report.md) | dbo.CASafes | SafesList.txt |
| 7 | [Owners List Report](07_Owners_List_Report.md) | dbo.CAOwners | OwnersList.txt |
| 8 | [Files List Report](08_Files_List_Report.md) | dbo.CAFiles | FilesList.txt |
| 9 | [User and Safe Activities Report](09_User_Safe_Activities_Report.md) | dbo.CALog | LogList.txt |
| 10 | [Master Policy Report](10_Master_Policy_Report.md) | (key-value) | MasterPolicySettings.txt |
| 11 | [System Log Report (ITALog)](11_System_Log_Report.md) | (separate file) | ITALogFile.txt |
| 12 | [Requests List Report](12_Requests_List_Report.md) | dbo.CARequests | RequestsList.txt |
| 13 | [Confirmations List Report](13_Confirmations_List_Report.md) | dbo.CAConfirmations | ConfirmationsList.txt |
| 14 | [Events List Report](14_Events_List_Report.md) | dbo.CAEvents | EventsList.txt |
| 15 | [Object Properties Report](15_Object_Properties_Report.md) | dbo.CAObjectProperties | ObjectProperties.txt |

---

## Notes for AI/SQL Generation

- **Environment schema takes precedence** — if column lengths or types differ between vendor docs and the environment schema, use the environment schema for SQL generation
- **Vendor docs provide descriptions** — use these files to understand what columns mean, valid values, and relationships
- **CATextCodes is essential** — many integer columns decode via this lookup table
- **CAObjectProperties is EAV** — always pivot when building flat reports; see the properties catalog for known property names
- **CAOwners may be missing** — check if your environment imports this table; it's critical for access reviews
