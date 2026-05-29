# EVD Pipeline Router

This sub-workspace transforms natural language requests into validated vault data reports through four sequential stages (stage 04 is optional).

## Pipeline Stages

1. **01_sql_gen** — Translates plain English requests into SQL queries using the database schema.
2. **02_data_fetch** — Executes the SQL via local PowerShell scripts and exports results to CSV.
3. **03_parsing** — Analyzes the CSV output against vault naming standards to identify compliance issues.
4. **04_remediation** — Translates Stage 3 compliance findings into a prioritized, actionable remediation plan.

## Execution Logic

- **Sequential**: Stage 02 cannot begin until Stage 01 has produced a verified SQL artifact. Stage 04 cannot begin until Stage 03 has produced a compliance report.
- **Output-as-Input**: Each stage's `output/` folder is the Layer 4 input for the next stage.
- **Output artifact standards**: Use `references/output_artifact_standards.md` for canonical output file names, formats, locations, and archive naming. Canonical files are the active stage handoff files; archived files are retained history.
- **Review Gates**: Every stage stops after writing its output. Inspect the `output/` directory before triggering the next stage.
- **Stage 4 is optional**: Proceed to Stage 4 only when the user wants a prioritized remediation plan. If the user wants to go directly to psPAS execution, they can take the Stage 3 output there instead.

## References

- Database schema: `references/_Schema_EVD_CyberArk_DB.md`
- EAV property catalog: `references/_Schema_EVD_CAOObjectProperties_Table.md`
- EAV query patterns (on-demand): `references/eva_query_patterns.md` — Join strategy and boolean property handling for CAObjectProperties pivots. Load when writing queries that pivot EAV properties.
- Vendor schema (on-demand): `references/vendor_schema/_INDEX.md` — Out-of-box report definitions. Load a specific file only when column meaning needs clarification; the environment schema always wins for types/lengths.
- System safe exclusions (on-demand): `references/system_safe_exclusions.md` — Default safe filters applied unless overridden.
- Query templates (on-demand): `references/query_templates/_INDEX.md` — Consult the index first; load only the matching template.
- Output artifact standards: `references/output_artifact_standards.md` — Canonical file names, output locations, and formats for EVD stage artifacts.
- Vault data naming standards: `references/naming_standards.md` — CyberArk internal naming rules for safes, platform IDs, account objects, and compliance rule IDs. This is not a file naming standard.
