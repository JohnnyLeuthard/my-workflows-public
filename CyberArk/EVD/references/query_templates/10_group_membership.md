# Group Membership

> **Category**: Access Review
> **Tables**: dbo.CAGroups, dbo.CAGroupMembers, dbo.CAUsers
> **Requires**: —
> **Note**: `CAGMMemberIsGroup` is nvarchar — `'False'` = user member, `'True'` = nested group member. `CAGMUserID` links to `CAUsers.CAUserID`. `CAGExternalInternal` = 0 for vault-local groups, 1 for LDAP/external groups.

---

## Description

Enumerate vault group membership rosters, identify empty groups, and surface groups with no active members. Useful for access certification reviews, confirming group-based safe permissions are still warranted, and cleaning up orphaned groups that may retain safe access.

Variant A returns one row per group–member pair (roster view). Variant B returns one row per group with a member count and an `IsEmpty` flag (summary view).

---

## Customization Points

| Parameter | Default | Location in SQL | Description |
|-----------|---------|-----------------|-------------|
| Group name filter | *(none)* | Add `WHERE g.CAGGroupName LIKE '...'` | Narrow to groups matching a naming pattern |
| Member type | User members only | `CAGMMemberIsGroup = 'False'` | Change to `'True'` to show nested group links instead |
| Empty groups only | No | Uncomment `HAVING COUNT(...) = 0` in Variant B | Show only groups with zero user members |

---

## SQL — Variant A (Full Roster)

```sql
SELECT
    g.CAGGroupName                  AS GroupName,
    g.CAGDescription                AS GroupDescription,
    g.CAGLocationName               AS GroupLocation,
    g.CAGExternalInternal           AS GroupType,   -- 0 = vault-local, 1 = LDAP/external
    u.CAUserName                    AS MemberUserName,
    u.CAUFirstName                  AS MemberFirstName,
    u.CAULastName                   AS MemberLastName,
    u.CAUDisabled                   AS MemberDisabled,
    u.CAULastLogonDate              AS MemberLastLogon,
    m.CAGMMemberIsGroup             AS IsNestedGroup -- 'False' = user, 'True' = nested group
FROM dbo.CAGroups g
LEFT JOIN dbo.CAGroupMembers m
    ON m.CAGMGroupID = g.CAGGroupID
    AND m.CAGMMemberIsGroup = 'False'   -- user members only; change to 'True' for nested groups
LEFT JOIN dbo.CAUsers u
    ON u.CAUserID = m.CAGMUserID
-- CUSTOMIZE: uncomment to filter to a specific group naming pattern
-- WHERE g.CAGGroupName LIKE 'CyberArk%'
ORDER BY
    g.CAGGroupName ASC,
    u.CAUserName ASC;
```

---

## SQL — Variant B (Group Summary with Empty Flag)

```sql
SELECT
    g.CAGGroupName                  AS GroupName,
    g.CAGDescription                AS GroupDescription,
    g.CAGLocationName               AS GroupLocation,
    g.CAGExternalInternal           AS GroupType,   -- 0 = vault-local, 1 = LDAP/external
    COUNT(m.CAGMUserID)             AS MemberCount,
    CASE
        WHEN COUNT(m.CAGMUserID) = 0 THEN 'Yes'
        ELSE 'No'
    END                             AS IsEmpty
FROM dbo.CAGroups g
LEFT JOIN dbo.CAGroupMembers m
    ON m.CAGMGroupID = g.CAGGroupID
    AND m.CAGMMemberIsGroup = 'False'
-- CUSTOMIZE: uncomment to filter to a specific group naming pattern
-- WHERE g.CAGGroupName LIKE 'CyberArk%'
GROUP BY
    g.CAGGroupName,
    g.CAGDescription,
    g.CAGLocationName,
    g.CAGExternalInternal
-- CUSTOMIZE: uncomment to return ONLY empty groups
-- HAVING COUNT(m.CAGMUserID) = 0
ORDER BY
    MemberCount ASC,
    g.CAGGroupName ASC;
```

---

## Output Columns

### Variant A

| Column | Description |
|--------|-------------|
| GroupName | Vault group name |
| GroupDescription | Group description |
| GroupLocation | Vault location the group belongs to |
| GroupType | 0 = vault-local group, 1 = LDAP/external group |
| MemberUserName | Vault username of the group member (NULL if group is empty) |
| MemberFirstName | Member's first name |
| MemberLastName | Member's last name |
| MemberDisabled | Whether the member's vault account is disabled |
| MemberLastLogon | Most recent logon date for the member |
| IsNestedGroup | `'False'` for user members, `'True'` for nested group links |

### Variant B

| Column | Description |
|--------|-------------|
| GroupName | Vault group name |
| GroupDescription | Group description |
| GroupLocation | Vault location the group belongs to |
| GroupType | 0 = vault-local group, 1 = LDAP/external group |
| MemberCount | Number of direct user members (not counting nested groups) |
| IsEmpty | `'Yes'` if the group has no user members, `'No'` otherwise |
