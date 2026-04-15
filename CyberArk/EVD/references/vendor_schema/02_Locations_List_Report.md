# Locations List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CALocations`
> **Export File**: `LocationsList.txt`
> **Vendor Docs**: [Locations List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/locations-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains a list of all locations defined in the Vault hierarchy. Locations are used to organize Users, Groups, and Safes within the Vault's logical structure.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | LocationID | CALocationID | Unique identifier for the location |
| 2 | LocationName | CALocationName | Full path name of the location in the Vault hierarchy (e.g., `\Root\US\DataCenter1`) |
| 3 | VaultID | CALVaultID | Identifier of the Vault instance |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CAUsers | CALocationID | Users assigned to this location |
| CASafes | CASLocationID | Safes assigned to this location |
| CAGroups | CAGLocationID | Groups assigned to this location |

---

## Usage Notes

- The root location is typically `\` or `\Root`
- Location hierarchy is represented by backslash-delimited paths in `LocationName`
- Used primarily for organizational/reporting purposes, not access control
