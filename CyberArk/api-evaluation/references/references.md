# External References

Authoritative sources for CyberArk PAM Self-Hosted REST API documentation, and pointers to related material elsewhere in the workspace.

## CyberArk official docs

The docs URL is built from the **major.minor** portion of the version only.

Pattern:

```
https://docs.cyberark.com/pam-self-hosted/<major.minor>/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm
```

| Version | Docs URL |
|---|---|
| 12.2 | https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm |
| 14.2 | https://docs.cyberark.com/pam-self-hosted/14.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm |
| 14.4 | https://docs.cyberark.com/pam-self-hosted/14.4/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm |

> When `Fetch-APIDocumentation.ps1 -Version 14.2.1` runs, it normalizes to `14.2` for the URL but retains `v14.2.1` as the folder name.

## Cross-workspace references (do not duplicate content)

| Resource | Location | Why it matters here |
|---|---|---|
| Deployed-version consolidated API reference | [../../cyberark-api/references/api/](../../cyberark-api/references/api/) | When a tracked version matches the currently deployed PVWA (per `_config/environment.md`), that folder holds the operator-facing consolidated reference. This workspace keeps the per-version historical snapshot. |
| Auth methods | [../../cyberark-api/references/auth_methods.md](../../cyberark-api/references/auth_methods.md) | Auth reference (CyberArk / LDAP / RADIUS / SAML / PKI) — logon endpoint per method |
| Error codes | [../../cyberark-api/references/error_codes.md](../../cyberark-api/references/error_codes.md) | HTTP status + CyberArk error body handling |
| Source-of-truth tracker | [../../cyberark-api/references/_SOURCE.md](../../cyberark-api/references/_SOURCE.md) | Declares which PVWA version the consolidated reference tracks |
| Environment config | [../../_config/environment.md](../../_config/environment.md) | Declares deployed PVWA version per tier |
| Naming standards | [../../EVD/references/naming_standards.md](../../EVD/references/naming_standards.md) | Safe / account / platform naming rules |

## Version conventions

- Folder name: full version (`v12.2`, `v14.2.1`, `v14.4.0`)
- Docs URL segment: major.minor only (`12.2`, `14.2`, `14.4`)
- Comparison export filename: keeps the full version (`comparison_v12.2_to_v14.2.1_YYYYMMDD.md`)
