# Stage: Remediation Planning

**Job**: Translate Stage 3 compliance findings into a prioritized, actionable remediation plan organized by severity.

## Inputs

- **Layer 4 (Working)**: `stages/03_parsing/output/compliance_report.md` — Compliance findings from Stage 3 (absolute path from EVD folder root). Primary input.
- **Layer 3 (Reference)**: `references/naming_standards.md` — Defines what "correct" looks like for each rule. Determines the target state for every action item (located in EVD folder).
- **Layer 3 (Reference, on-demand)**: `references/query_templates/_INDEX.md` — Optionally consulted to suggest follow-up EVD queries that verify remediation was applied correctly.

## Process

1. Read `compliance_report.md` and extract all findings, preserving rule ID, object name, severity, and violation description.
2. Group findings by rule ID (NS-S01 through NS-A03).
3. Within each rule group, sort by severity (High → Medium → Low).
4. For each finding, produce a discrete action item: Object, Rule Violated, Severity, What Is Wrong, What Correct Looks Like, Recommended Action.
5. Write an Executive Summary section with counts by severity and a short narrative.
6. Write an Automation Routing section indicating which finding types can be automated via psPAS vs. require manual PVWA action.
7. Write a Validation Queries section suggesting follow-up EVD templates to confirm that remediation was applied correctly.

## Outputs

- **Remediation plan** → `stages/04_remediation/output/remediation_plan.md` (absolute path from EVD folder root)

### Output File Structure

```
# Remediation Plan
Generated from: stages/03_parsing/output/compliance_report.md
Generated: [date]

## Executive Summary
[Severity | Count | Impact table]
[One-paragraph narrative of top priority issues]

## Priority 1 — High Severity
[One sub-section per rule ID with High findings]
[Object | Safe | What Is Wrong | Correct Target | Action table per rule]

## Priority 2 — Medium Severity
[Same structure]

## Priority 3 — Low Severity
[Same structure]

## Automation Routing
[Finding Type | Rule IDs | psPAS Automatable? | Manual Action table]
[Note: safe renames require PVWA Administration — psPAS cannot rename safes]
[Close with: "To automate eligible items, take this plan to CyberArk/psPAS/ Stage 01 Planning."]

## Validation Queries
[Suggested follow-up EVD templates to confirm remediation was applied]
```

## Review Gate

Stop here. The human reviews the remediation plan.

- **To automate**: Take `stages/04_remediation/output/remediation_plan.md` to `CyberArk/psPAS/stages/01_planning/` as the compliance input.
- **To remediate manually**: Work through the Priority 1–3 action tables directly in PVWA, using the "Correct Target" column as the exact value to enter.
- **To verify**: After remediation, re-run the relevant EVD query templates (listed in the Validation Queries section) to confirm findings are resolved.
