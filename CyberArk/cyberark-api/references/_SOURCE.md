# API Reference Source of Truth

This document tracks the **authoritative source** for all CyberArk REST API documentation used in this workspace.

---

## Primary Source

**CyberArk PVWA REST API Documentation (v14.4)**

- **URL**: https://docs.cyberark.com/pam-self-hosted/14.4/en/content/webservices/implementing%20privileged%20account%20security%20web%20services%20.htm?tocpath=Developer%7CREST%20APIs%7C_____0
- **Version**: 14.4.x (matches `../_config/environment.md`)
- **Access**: Online documentation (primary source)
- **Last Verified**: 2026-04-16

---

## Local Reference Files

Local markdown files in `api/` are **cached snapshots** of the online docs, created to support offline access and version tracking.

| Local File | Covers | Online Docs Section | Last Updated | Version |
|---|---|---|---|---|
| `api/_INDEX.md` | Endpoint overview & routing | TOC / Overview | TBD | 14.4 |
| `api/01_auth.md` | Authentication & logon | Logon API | TBD | 14.4 |
| `api/02_accounts.md` | Account operations | Accounts API | TBD | 14.4 |
| `api/03_safes.md` | Safe & member operations | Safes API | TBD | 14.4 |
| `api/04_users.md` | User & group operations | Users API | TBD | 14.4 |
| `api/05_platforms.md` | Platform operations | Platforms API | TBD | 14.4 |
| `api/06_system_health.md` | System health & status | System API | TBD | 14.4 |

---

## Update Process

When updating to a new PVWA version:

1. **Update `../_config/environment.md`** to the new version number
2. **Update this file** (`_SOURCE.md`) with the new external URL
3. **Walk through the online docs** section-by-section
4. **Update each local file** in `api/` with new endpoints, parameters, and response shapes
5. **Change "Last Updated" and "Version"** columns above
6. **Mark stub status** in `_INDEX.md` as "Current" when done

---

## Offline Access Rules

- If the external URL is unreachable, Claude falls back to local `api/*.md` files
- Offline mode is **not guaranteed to be current** — always check the version in `../_config/environment.md` and this file
- If local docs are outdated, manually update them or contact a team member with online access

