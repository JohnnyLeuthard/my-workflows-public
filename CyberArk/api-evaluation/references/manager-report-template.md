# Manager Report Template

Executive-facing write-up of an API version comparison. Saved under `reports/`. Derive content from `exports/comparison_v{From}_to_v{To}_YYYYMMDD.md`, but rephrase for a non-technical audience and lead with impact, not mechanics.

---

```markdown
# CyberArk PAM API Change Report — v<From> → v<To>

**Date:** <YYYY-MM-DD>
**Prepared for:** <stakeholder / team>
**Deployment context:** <e.g., planning upgrade from v<From> to v<To> in PROD>

## Executive Summary

Two to four sentences. State the delta in plain terms (e.g., "Version X introduces N new endpoints primarily around session management, removes M legacy authentication endpoints, and modifies the Accounts category in a way that requires a small change to our rotation scripts"). State the bottom-line recommendation.

## Added

| Area | What's new | Why it matters |
|---|---|---|
| <Category> | <one-line> | <business or security impact> |

## Removed

| Area | What's gone | Impact |
|---|---|---|
| <Category> | <one-line> | <who relied on it, if known> |

## Modified

| Area | What changed | Impact |
|---|---|---|
| <Category> | <one-line> | <caller-visible effect> |

## Breaking Changes

Enumerate only changes that will break existing scripts, integrations, or automations if the upgrade ships without remediation.

1. **<Area / endpoint>** — <plain-language description of the break and who is affected>
2. ...

## Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| <e.g., Rotation automation will fail> | High / Medium / Low | <action + owner> |

## Recommended Actions

Ordered list, each with an owner and target date.

1. <Action> — Owner: <name>, Target: <YYYY-MM-DD>
2. ...

## References

- Comparison export: `exports/comparison_v<From>_to_v<To>_<YYYYMMDD>.md`
- Vendor docs (From): https://docs.cyberark.com/pam-self-hosted/<From major.minor>/en/content/webservices/
- Vendor docs (To): https://docs.cyberark.com/pam-self-hosted/<To major.minor>/en/content/webservices/
```

---

## Rules for authoring

- Scope is **API changes only**. Documentation-only diffs (wording, formatting, example tweaks) never appear in a manager report.
- Lead with impact, not mechanics. The reader cares "what breaks, what's new, what should we do" — not raw endpoint counts.
- Every Breaking Change entry must have a named mitigation in the Risk Assessment table.
- Recommended Actions must have owners and target dates, or flag `Owner: TBD` / `Target: TBD` explicitly.
