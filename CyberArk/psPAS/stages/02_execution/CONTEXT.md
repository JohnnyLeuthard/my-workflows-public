# Stage: Remediation Execution

**Job**: Execute the approved remediation plan by generating psPAS PowerShell commands for vault changes.

## Inputs

- **Layer 4 (Working)**: `../01_planning/output/remediation_plan.md` — The approved remediation plan.
- **Layer 3 (Reference)**: `../01_planning/references/pspas_cmdlets.md` — Cmdlet syntax reference.

## Process

1. Parse each action item from the approved remediation plan.
2. For each item, construct the corresponding psPAS PowerShell command.
3. Generate a PowerShell script that executes the changes sequentially.
4. Hand off the script to `../../../scripts/` for mechanical execution.

## Outputs

- `execution_script.ps1` → `output/execution_script.ps1`
- `execution_log.md` → `output/execution_log.md`

## Review Gate

Stop here. The human reviews the generated script before running it. After execution, inspect the log to confirm all changes were applied successfully.
