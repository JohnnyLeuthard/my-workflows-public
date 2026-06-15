# CCP Stage 04 Router: Endpoint Testing

## Use This Stage For

- Running approved live endpoint checks against CCP targets.
- Recording connectivity, HTTP status, error category, and redacted response notes.
- Producing `output/test_report.md`.

## Required Inputs

- `../03_uri_builder/output/uri_set.md`
- Explicit human approval naming the environment, target, port, and request item set to test.

## Stop Rule

After producing or updating the endpoint test report, stop and wait for human review.
