# CCP Output Artifact Standards

Use canonical output files for normal staged work. Do not create timestamped duplicates unless the user explicitly asks for an archive or comparison.

| Stage | Artifact | Canonical path | Format |
|-------|----------|----------------|--------|
| 01_config_model | CCP target/config model | `CyberArk/CCP/stages/01_config_model/output/config_model.md` | Markdown |
| 02_request_catalog | Request item catalog | `CyberArk/CCP/stages/02_request_catalog/output/request_catalog.md` | Markdown |
| 03_uri_builder | Built URI set | `CyberArk/CCP/stages/03_uri_builder/output/uri_set.md` | Markdown |
| 04_endpoint_testing | Endpoint test report | `CyberArk/CCP/stages/04_endpoint_testing/output/test_report.md` | Markdown |
| 05_interface_planning | Interface plan | `CyberArk/CCP/stages/05_interface_planning/output/interface_plan.md` | Markdown |

## Secret Handling

- Redact credential values and tokens before writing any output.
- Prefer documenting request metadata and status over storing response bodies.
- If a response body is needed for troubleshooting, get explicit approval and redact it before saving.
