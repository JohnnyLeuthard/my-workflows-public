# Version Comparison Template

Output shape for `Compare-APIVersions.ps1`. Files land in `exports/comparison_v{From}_to_v{To}_YYYYMMDD.md`.

---

```markdown
# API Comparison — v<From> → v<To>

**Generated:** <YYYY-MM-DD>
**From build:** <build or "unknown">
**To build:** <build or "unknown">
**From source:** https://docs.cyberark.com/pam-self-hosted/<From major.minor>/en/content/webservices/
**To source:** https://docs.cyberark.com/pam-self-hosted/<To major.minor>/en/content/webservices/

## Summary

| Metric | Count |
|---|---|
| Endpoint categories in From | <n> |
| Endpoint categories in To | <n> |
| Added categories | <n> |
| Removed categories | <n> |
| Modified categories | <n> |
| Total endpoints added | <n> |
| Total endpoints removed | <n> |
| Total endpoints modified | <n> |

## Added Categories

Categories present in v<To> but not in v<From>.

- `<Category>` — <n> endpoints

## Removed Categories

Categories present in v<From> but not in v<To>.

- `<Category>` — <n> endpoints

## Modified Categories

Categories present in both versions whose endpoint list or signatures differ.

### `<Category>`

**Added endpoints**
| Method | Endpoint | Description |
|---|---|---|
| GET | /api/... | ... |

**Removed endpoints**
| Method | Endpoint | Description |
|---|---|---|
| DELETE | /api/... | ... |

**Modified endpoints** (path/method unchanged but signature changed)
| Method | Endpoint | Change |
|---|---|---|
| PUT | /api/... | New required field `x` in request body |

## Breaking Changes

Endpoints whose change would break existing callers (removed endpoint, removed field, required-field addition, behavior change).

- `<METHOD> /api/...` — <why it breaks>

## Non-Breaking Changes

Endpoints whose change is backward compatible (new optional field, new response field, new endpoint).

- `<METHOD> /api/...` — <change>

## Notes

Documentation-only differences (wording, examples, formatting) are **excluded** from this report. Only surface API-surface changes.
```
