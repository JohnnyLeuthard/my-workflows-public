# Endpoint Documentation Template

This is the mandatory format for every file under `v{version}/endpoints/`. Every endpoint file must include every section below. If a section has no content for the endpoint, write `N/A` — do not omit the section.

One file covers one **category** (e.g., `Accounts.md`, `Safes.md`). A category can contain multiple endpoints — list each one under the Overview Table and then repeat the per-endpoint sections for each.

---

## Template body

```markdown
---
filename: <Category>.md
version: <major.minor[.patch]>
source_url: https://docs.cyberark.com/pam-self-hosted/<major.minor>/en/content/webservices/<vendor-anchor>.htm
build: <e.g. 8.2.5>
status: <Populated | Framework only | Stale>
---

# <Category>

One-paragraph summary of what this category covers.

## Overview

| Method | Endpoint | Description | Auth Required |
|---|---|---|---|
| GET | /api/... | ... | Yes |
| POST | /api/... | ... | Yes |

---

## <Endpoint name 1>

### Purpose
What this endpoint does, in one or two sentences.

### Full Path
`<METHOD> /api/...`

### HTTP Method
GET | POST | PUT | PATCH | DELETE

### Auth
Required session token header, permissions needed, and any auth caveats.

### URL Params
| Name | Type | Required | Description |
|---|---|---|---|
| ... | ... | Yes/No | ... |

### Query Params
| Name | Type | Required | Description |
|---|---|---|---|
| ... | ... | Yes/No | ... |

### Headers
| Header | Value | Notes |
|---|---|---|
| Authorization | <session token> | Required |
| Content-Type | application/json | For request bodies |

### Request Body
```json
{
  "field": "value"
}
```

### Response (200)
```json
{
  "field": "value"
}
```

### Field Descriptions
| Field | Type | Description |
|---|---|---|
| ... | ... | ... |

### Return Codes
| Code | Meaning | Notes |
|---|---|---|
| 200 | Success | ... |
| 400 | Bad Request | ... |
| 401 | Unauthorized | ... |
| 403 | Forbidden | ... |
| 404 | Not Found | ... |

### Notes
Version-specific behavior, quirks, deprecation warnings, rate limits.

### Related Endpoints
- `<METHOD> /api/...` (in <Category>.md)

---

## <Endpoint name 2>
...repeat the per-endpoint sections above...
```

---

## Rules

- Frontmatter is required on every endpoint file.
- The Overview table is required and must list every endpoint contained in the file.
- Every per-endpoint block must contain every section listed above, even if the value is `N/A`.
- Never invent a field, parameter, or return code. If the live CyberArk docs do not show it, it does not go in the file.
- Code fences around request/response bodies use the appropriate language tag (`json`, `xml`, etc.) — not bare triple backticks.
