# Stage: Compliance Parsing

**Job**: Analyze the retrieved CSV data against vault naming standards to identify non-compliant accounts.

## Inputs

- **Layer 4 (Working)**: `stages/02_data_fetch/output/vault_data.csv` — Raw data exported in Stage 2 (absolute path from EVD folder root).
- **Layer 3 (Reference)**: `references/naming_standards.md` — Organization naming conventions to check against (located in EVD folder).

## Process

1. Load the CSV data from Stage 02's output.
2. Parse each row, extracting account names and relevant metadata fields.
3. Compare each account against the naming rules defined in `naming_standards.md`.
4. Flag any accounts that do not comply, noting the specific rule violation.
5. Generate a compliance summary report.

## Outputs

- **Compliance report** → `stages/03_parsing/output/compliance_report.md` (absolute path from EVD folder root)

## Review Gate

Stop here. The human reviews the compliance report.

- **To plan remediation**: Proceed to Stage 4 (`stages/04_remediation/`) to generate a prioritized remediation plan (with recommended actions, severity grouping, and automation routing) before deciding whether to use psPAS.
- **To go directly to psPAS**: Non-compliant accounts identified here can also be taken directly to `CyberArk/psPAS/` as input.
- **If no compliance issues**: If the compliance report shows zero findings, the pipeline is complete.
