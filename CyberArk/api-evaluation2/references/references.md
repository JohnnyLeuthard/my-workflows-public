# Reference Guide

This folder contains templates and canonical documents for the API Evaluation workspace.

## Files in This Folder

### endpoint-template.md

The canonical template for all endpoint documentation files. Every file in `self-hosted/v12.2/endpoints/`, `self-hosted/v14.2/endpoints/`, `privilege-cloud/*/endpoints/` must follow this structure.

**Use for**:
- Creating new endpoint files
- Validating completeness of existing endpoint docs
- Ensuring consistency across versions

**Key sections**:
- Header (file, version, platform, source, status)
- Overview (method, endpoint, description, auth)
- Purpose, Full Path, HTTP Method
- Authentication, Parameters (URL/query/headers)
- Request Body (JSON schema + field descriptions)
- Response Codes
- Notes, Related Endpoints

**Example**: See `self-hosted/v12.2/endpoints/Accounts.md`

---

### version-comparison-template.md

Template for raw technical comparison data output from the `Compare-APIVersions.ps1` script. Contains detailed endpoint-by-endpoint changes.

**Use for**:
- Raw output from `Compare-APIVersions.ps1` script (basis for reports)
- Identifying breaking changes between versions
- Data source for manager and developer reports

**Key sections**:
- Executive Summary (changes count, migration complexity)
- Changes by Category (Added, Modified, Deprecated, Removed)
- Breaking Changes Analysis (with risk assessment)
- Migration Checklist
- Detailed endpoint-by-endpoint comparison

**Output location**: `exports/comparison_[platform]_v[X.X]_to_v[X.X]_YYYYMMDD.md`

**Note**: This is raw script output. For polished reports, see manager-report-template.md and developer-report-template.md

**Example**: Run `Compare-APIVersions.ps1 -From 12.2 -To 14.2` to generate

---

### manager-report-template.md

Template for non-technical executive summary reports. Focuses on business impact, risk, and decision-making. Audience: managers, compliance teams, and stakeholders making upgrade decisions.

**Use for**:
- Communicating to managers/stakeholders
- Upgrade approval decisions
- Compliance/risk sign-off
- Presenting high-level impact and timeline

**Key sections**:
- Executive Summary (what changed, risk level, recommendation)
- What Changed (new features, breaking changes, risk assessment)
- Recommended Actions (before/during/after upgrade)
- Timeline & Resource Requirements
- Decision Matrix (Go/Schedule/Defer)
- Sign-off (approval from manager/director)

**Output location**: `reports/manager/manager_[platform]_v[X.X]_to_v[X.X]_YYYYMMDD.md`

**Platform tag**: `sh` = Self-Hosted, `pc` = Privilege Cloud

**Who uses this**: Management, compliance teams, stakeholders making upgrade decisions

---

### developer-report-template.md

Template for technical migration guides. Provides code-level details on what changed and how to update your code. Audience: engineers, integration owners, and API consumers.

**Use for**:
- Communicating to developers/engineers
- Code migration planning
- Implementation tracking
- Breaking change mitigation

**Key sections**:
- At a Glance (quick metrics)
- Breaking Changes (must fix before upgrade)
- New Endpoints (optional adoption)
- Removed Endpoints (migration required)
- Parameter Changes (review and update)
- Authentication Changes (if applicable)
- Response Format Changes (if applicable)
- Migration Checklist (pre/testing/post)
- Code Review Areas
- Related Resources

**Output location**: `reports/developer/developer_[platform]_v[X.X]_to_v[X.X]_YYYYMMDD.md`

**Platform tag**: `sh` = Self-Hosted, `pc` = Privilege Cloud

**Who uses this**: Engineers, integration owners, anyone updating code for the new version

---

## How to Use These Templates

### Creating a New Endpoint File

1. Copy `endpoint-template.md`
2. Fill in the Header section (filename, version, **platform**, source URL, status)
3. Complete Overview table
4. Write Purpose, Full Path, HTTP Method sections
5. Add Authentication requirements
6. Document Parameters (URL, query, header)
7. Add Request Body schema (if applicable)
8. List Response Codes
9. Add Notes and Related Endpoints
10. Save to appropriate version folder: `self-hosted/v12.2/endpoints/[Name].md` or `privilege-cloud/v[X.X]/endpoints/[Name].md`

### Comparing Two Versions (Raw Comparison Data)

1. Run: `Compare-APIVersions.ps1 -From 12.2 -To 14.2` (defaults to Self-Hosted)
2. Or for Privilege Cloud: `Compare-APIVersions.ps1 -From 14.2 -To 24.1 -Platform PC`
3. Script uses `version-comparison-template.md` as basis
4. Output: `exports/comparison_sh-v12.2_to_sh-v14.2_YYYYMMDD.md` (raw script output)
5. This becomes the data source for manager and developer reports

### Creating a Manager Report

1. Run the comparison: `Compare-APIVersions.ps1 -From 12.2 -To 14.2 [-Platform SH|PC]`
2. Review raw comparison output in `exports/comparison_[platform]_v[X.X]_to_v[X.X]_[date].md`
3. Copy `manager-report-template.md`
4. Fill in header: Report Date, Platform, Versions, Prepared For, Status
5. Fill in metrics: new endpoints, breaking changes, risk level
6. Summarize new features (business value, who benefits)
7. List breaking changes (impact, action required)
8. Complete Risk Assessment
9. Provide Recommended Actions (timeline, team, effort)
10. Add Sign-Off section
11. Save to `reports/manager/manager_[platform]_v[X.X]_to_v[X.X]_YYYYMMDD.md`

### Creating a Developer Report

1. Run the comparison (see Manager Report step 1)
2. Review raw comparison output in `exports/`
3. Copy `developer-report-template.md`
4. Fill in header: Platform, From/To versions, Report Date
5. List at-a-glance metrics
6. Detail breaking changes with code examples (what changed, how to fix)
7. List new endpoints (when to use them)
8. List removed endpoints (replacement paths)
9. Document parameter changes (old vs new)
10. Add authentication/response format changes (if applicable)
11. Complete the migration checklist template
12. Add code review areas to watch
13. Save to `reports/developer/developer_[platform]_v[X.X]_to_v[X.X]_YYYYMMDD.md`

---

## Template Versioning

| Template | Current Version | Last Updated |
|----------|---|---|
| endpoint-template.md | 1.1 | 2026-05-03 |
| version-comparison-template.md | 1.0 | 2026-05-03 |
| manager-report-template.md | 1.1 | 2026-05-03 |
| developer-report-template.md | 1.0 | 2026-05-03 |

**Note**: Templates are living documents. If improvements are needed, update this file and increment version numbers.

---

## Customization

### Extending Endpoint Template

If a specific endpoint requires additional sections (e.g., WebSocket details, deprecated parameters), extend the template but keep the core structure intact:

```markdown
# [Endpoint Name]

## Header
[Standard header section]

## Overview
[Standard overview]

## Purpose
[Standard purpose]

## Full Path
[Standard paths]

## [Custom Section — Example: "WebSocket Details"]
[Add custom documentation here]

## HTTP Method
[Standard HTTP method]

## ... (rest of template)
```

### Customizing Reports

Manager reports and comparison reports can be customized by:
1. Extending the Decision Matrix with organization-specific factors
2. Adding custom Sign-Off roles (Security, Compliance, etc.)
3. Expanding Risk Assessment with organization-specific risks
4. Adding sections for specific team concerns

---

## Notes

- All templates use Markdown for consistency and version control friendliness
- Templates are designed for both human reading and programmatic processing
- Keep template changes minimal — they affect all downstream documents
- Before updating templates, consult the team (templates are contract between docs and scripts)
