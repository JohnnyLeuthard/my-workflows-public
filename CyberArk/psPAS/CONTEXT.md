# psPAS Remediation Pipeline Router

This sub-workspace manages vault remediation tasks using the psPAS PowerShell module (a CyberArk REST API wrapper).

## Pipeline Stages

1. **01_planning** — Analyzes compliance data and generates a remediation plan: which accounts to change, what actions to take.
2. **02_execution** — Executes the approved plan by calling psPAS cmdlets via PowerShell scripts.

## Execution Logic

- **Sequential**: Stage 02 cannot begin until the remediation plan from Stage 01 has been reviewed and approved.
- **Output-as-Input**: The `output/` folder of Stage 01 provides the plan that Stage 02 consumes.
- **Critical review gate**: The plan MUST be human-approved before any vault modifications occur. This is a destructive pipeline — changes affect production.

## Cross-Workspace Input

This pipeline often receives its initial input from the EVD parsing stage:
- `../EVD/stages/03_parsing/output/compliance_report.md`

The compliance report identifies which accounts need remediation. However, this pipeline can also accept direct user input without prior EVD analysis.
