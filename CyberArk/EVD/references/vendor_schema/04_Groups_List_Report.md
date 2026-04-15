# Groups List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CAGroups`
> **Export File**: `GroupsList.txt`
> **Vendor Docs**: [Groups List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/groups-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains a list of all groups defined in the Vault, including both internal Vault groups and externally mapped LDAP/directory groups.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | GroupID | CAGGroupID | Unique numeric identifier for the group |
| 2 | GroupName | CAGGroupName | Name of the group |
| 3 | LocationID | CAGLocationID | ID of the group's location in the Vault hierarchy |
| 4 | LocationName | CAGLocationName | Full path of the group's location |
| 5 | Description | CAGDescription | Group description text |
| 6 | ExternalGroupName | CAGExternalGroupName | External directory group name (if LDAP-mapped) |
| 7 | ExternalInternal | CAGExternalInternal | Whether the group is external or internal (`0` = internal, `1` = external) |
| 8 | LDAPFullDN | CAGLDAPFullDN | Full LDAP distinguished name if externally mapped |
| 9 | LDAPDirectory | CAGLDAPDirectory | LDAP directory name the group is mapped from |
| 10 | MapName | CAGMapName | LDAP mapping name |
| 11 | MapID | CAGMapID | LDAP mapping ID |
| 12 | VaultID | CAGVaultID | Vault instance identifier |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CALocations | CAGLocationID → CALocationID | Group's location |
| CAGroupMembers | CAGMGroupID → CAGGroupID | Members of this group |
| CAConfirmations | CACGroupID → CAGGroupID | Confirmations assigned to this group |

---

## Usage Notes

- Groups are used to assign Safe-level permissions collectively
- LDAP-mapped groups sync membership from the external directory
- Built-in groups include `Vault Admins`, `Auditors`, `Notification Engines`, etc.
