# Stage: Remediation Planning

**Job**: Analyze non-compliant accounts and generate a structured remediation plan specifying the exact changes to make.

## Inputs

- **Layer 4 (Working)**: `../../../EVD/stages/03_parsing/output/compliance_report.md` — OR a user-provided list of accounts to fix.
- **Layer 3 (Reference)**: `references/pspas_cmdlets.md` — Available psPAS cmdlets and their parameters.
- **Layer 3 (Reference)**: `../../../EVD/references/naming_standards.md` — Target naming conventions to remediate toward. *(Will move to `psPAS/references/` when this pipeline is built out.)*

## Process

1. Review the compliance report or user request to identify accounts requiring changes.
2. For each account, determine the correct psPAS cmdlet and parameters needed.
3. Cross-reference against `naming_standards.md` to derive the correct target values.
4. Generate a remediation plan listing each change as a discrete action item.

## Outputs

- `remediation_plan.md` → `output/remediation_plan.md`

## Review Gate

CRITICAL STOP. The remediation plan must be explicitly approved by the human operator before proceeding. This plan drives changes to the production vault. No automated progression past this point.
