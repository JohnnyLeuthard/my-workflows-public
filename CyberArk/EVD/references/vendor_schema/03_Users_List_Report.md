# Users List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CAUsers`
> **Export File**: `UsersList.txt`
> **Vendor Docs**: [Users List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/users-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains a list of all users defined in the Vault, their location in the Vault hierarchy, and their user properties. Includes both internal Vault users and externally mapped LDAP/directory users.

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | UserID | CAUserID | Unique numeric identifier for the user |
| 2 | UserName | CAUserName | Vault username |
| 3 | LocationID | CALocationID | ID of the user's location in the Vault hierarchy |
| 4 | LocationName | CALocationName | Full path of the user's location |
| 5 | FirstName | CAUFirstName | User's first name |
| 6 | LastName | CAULastName | User's last name |
| 7 | BusinessEmail | CAUBusinessEmail | User's email address |
| 8 | Disabled | CAUDisabled | Whether the user is disabled (`Yes`/`No`) |
| 9 | FromHour | CAUFromHour | Start of allowed logon hours (0–23) |
| 10 | ToHour | CAUToHour | End of allowed logon hours (0–23) |
| 11 | ExpirationDate | CAUExpirationDate | Date when the user account expires |
| 12 | PasswordNeverExpires | CAUPasswordNeverExpires | Whether password expiration is disabled (`Yes`/`No`) |
| 13 | LogRetentionPeriod | CAULogRetentionPeriod | Number of days to retain user activity logs |
| 14 | AuthenticationMethods | CAUAuthenticationMethods | Bitmask of enabled authentication methods (decode via CATextCodes Type 5) |
| 15 | Authorizations | CAUAuthorizations | Bitmask of Vault-level authorizations (decode via CATextCodes Type 3) |
| 16 | GatewayAccountAuthorizations | CAUGatewayAccountAuthorizations | Bitmask of gateway authorizations (decode via CATextCodes Type 4) |
| 17 | DistinguishedName | CAUDistinguishedName | Distinguished name for the user |
| 18 | ExternalInternal | CAUExternalInternal | Whether the user is external (LDAP-mapped) or internal Vault user |
| 19 | LDAPFullDN | CAULDAPFullDN | Full LDAP distinguished name if externally mapped |
| 20 | LDAPDirectory | CAULDAPDirectory | LDAP directory name the user is mapped from |
| 21 | MapName | CAUMapName | LDAP mapping name |
| 22 | MapID | CAUMapID | LDAP mapping ID |
| 23 | LastLogonDate | CAULastLogonDate | Date/time of the user's most recent logon |
| 24 | PrevLogonDate | CAUPrevLogonDate | Date/time of the user's previous logon |
| 25 | UserTypeID | CAUserTypeID | User type identifier (standard, batch, etc.) |
| 26 | RestrictedInterfaces | CAURestrictedInterfaces | Interfaces the user is restricted to |
| 27 | ApplicationMetadata | CAUApplicationMetadata | Application-specific metadata |
| 28 | CreationDate | CAUCreationDate | Date the user was created |
| 29 | VaultID | CAUVaultID | Vault instance identifier |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CALocations | CALocationID | User's location in the hierarchy |
| CAGroupMembers | CAGMUserID → CAUserID | Groups this user belongs to |
| CALog | CAAUserID → CAUserID | Activity log entries for this user |
| CARequests | CARUserID → CAUserID | Access requests by this user |
| CAConfirmations | CACUserID → CAUserID | Confirmations by this user |

---

## Usage Notes

- `Authorizations` and `AuthenticationMethods` are bitmask integers — decode using `CATextCodes`
- `ExternalInternal`: `0` = internal, `1` = external (LDAP-mapped)
- Built-in system users (e.g., `Master`, `Administrator`, `Batch`, `DR`) are included
- `Disabled = Yes` means the user cannot authenticate
