# Group Members List Report

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: `dbo.CAGroupMembers`
> **Export File**: `GroupMembersList.txt`
> **Vendor Docs**: [Group Members List Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/group-members-list-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains the membership relationships between users and groups. Each row represents one user's membership in one group. Groups can also contain other groups (nested groups).

---

## Columns (Out-of-Box)

| # | Column | DB Column | Description |
|---|--------|-----------|-------------|
| 1 | GroupID | CAGMGroupID | ID of the parent group |
| 2 | UserID | CAGMUserID | ID of the member (user or group) |
| 3 | MemberIsGroup | CAGMMemberIsGroup | Whether the member is itself a group (`Yes`/`No`) |
| 4 | VaultID | CAGMVaultID | Vault instance identifier |

---

## Relationships

| Related Table | Join Column | Description |
|---|---|---|
| CAGroups | CAGMGroupID → CAGGroupID | The parent group |
| CAUsers | CAGMUserID → CAUserID | The member user (when MemberIsGroup = No) |
| CAGroups | CAGMUserID → CAGGroupID | The member group (when MemberIsGroup = Yes) |

---

## Usage Notes

- When `MemberIsGroup = Yes`, the `UserID` column refers to a `CAGGroupID` (nested group), not a user
- To resolve full group membership including nested groups, use recursive queries
- Example — list all users in a group:

```sql
SELECT
    g.CAGGroupName,
    u.CAUserName
FROM dbo.CAGroupMembers gm
JOIN dbo.CAGroups g ON g.CAGGroupID = gm.CAGMGroupID
JOIN dbo.CAUsers u ON u.CAUserID = gm.CAGMUserID
WHERE gm.CAGMMemberIsGroup = 'No'
    AND g.CAGGroupName = 'Vault Admins'
```
