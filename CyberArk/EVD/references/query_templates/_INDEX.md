# EVD Query Templates

> Pre-built SQL patterns for common CyberArk vault queries.
> **Do not load eagerly.** Read this index first, then load only the template that matches the user's request.

---

## Template Catalog

| # | Template | Category | Primary Tables | On-Demand Refs Needed | File |
|---|----------|----------|----------------|----------------------|------|
| 1 | [Stale Accounts](01_stale_accounts.md) | Hygiene | CAFiles, CAObjectProperties | — | 01_stale_accounts.md |
| 2 | [CPM Health](02_cpm_health.md) | Operations | CAFiles, CAObjectProperties | datetime_handling.md | 02_cpm_health.md |
| 3 | [Safe Owners](03_safe_owners.md) | Access Review | CASafes, CALog | — | 03_safe_owners.md |
| 4 | [Account Inventory](04_account_inventory.md) | Inventory | CAFiles, CAObjectProperties | — | 04_account_inventory.md |
| 5 | [Platform Compliance](05_platform_compliance.md) | Compliance | CAFiles, CAObjectProperties | naming_standards.md | 05_platform_compliance.md |
| 6 | [Safe Summary](06_safe_summary.md) | Inventory | CASafes, CAFiles | — | 06_safe_summary.md |
| 7 | [Orphaned Accounts](07_orphaned_accounts.md) | Hygiene | CAFiles, CAObjectProperties | — | 07_orphaned_accounts.md |
| 8 | [Password Age](08_password_age.md) | Operations | CAFiles, CAObjectProperties | datetime_handling.md | 08_password_age.md |
| 9 | [User Lifecycle](09_user_lifecycle.md) | Access Review | CAUsers | — | 09_user_lifecycle.md |
| 10 | [Group Membership](10_group_membership.md) | Access Review | CAGroups, CAGroupMembers, CAUsers | — | 10_group_membership.md |
| 11 | [Request Audit](11_request_audit.md) | Operations | CARequests, CAConfirmations | — | 11_request_audit.md |
| 12 | [PSM Session Activity](12_psm_session_activity.md) | Operations | CAFiles, CAObjectProperties | datetime_handling.md (if filtering on PSMStartTime/EndTime) | 12_psm_session_activity.md |
| 13 | [Recently Onboarded Accounts](13_recently_onboarded.md) | Inventory | CAFiles, CAObjectProperties | — | 13_recently_onboarded.md |

---

## How to Use

1. Match the user's request to a template category above
2. Load only that template file
3. Review the SQL and customize parameters as needed for the user's specific request
4. The template SQL is complete and ready to run — system safe exclusions are already embedded
5. Write the final SQL to `stages/01_sql_gen/output/query.sql` and proceed through the normal review gate

## Notes

- Templates follow the same EAV pivot pattern documented in `../eva_query_patterns.md`
- System safe exclusions are embedded in each template — keep in sync with `../system_safe_exclusions.md`
- Templates are starting points — the AI should adjust columns, filters, and thresholds based on the user's actual request
