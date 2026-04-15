# System Log Report (ITALog)

> **Source**: CyberArk EVD Vendor Documentation (PAM Self-Hosted 14.2)
> **DB Table**: Exported as separate file (not a standard dbo.CA* table)
> **Export File**: `ITALogFile.txt`
> **Vendor Docs**: [System Log Report](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/system-log-report.htm)
> **Status**: Verify against live docs

---

## Description

Contains system-level log messages from the Vault server itself (ITA = IT Audit). These are operational messages about Vault service events, not user activities. Useful for troubleshooting Vault health and operations.

---

## Columns (Out-of-Box)

| # | Column | Description |
|---|--------|-------------|
| 1 | Date | Date/time of the log entry |
| 2 | MessageID | Numeric message identifier |
| 3 | Severity | Severity level (e.g., Information, Warning, Error) |
| 4 | Message | Full text of the log message |
| 5 | VaultID | Vault instance identifier |

---

## Common Message Categories

| MessageID Range | Category |
|----------------|----------|
| 1–99 | Vault startup and shutdown |
| 100–199 | Authentication events |
| 200–299 | Replication and DR |
| 300–399 | Backup operations |
| 400–499 | License and capacity |

> Verify exact ranges against vendor docs — [ITAlog Messages](https://docs.cyberark.com/pam-self-hosted/14.2/en/content/evd/italog-messages.htm)

---

## Usage Notes

- This is a system operational log, not a user audit log (use `CALog` for user activity)
- Useful for monitoring Vault health, DR replication status, and service events
- The ITALog may not be imported into the standard EVD SQL database in all configurations
- Check if your environment imports this file or if it's only available as a text export
