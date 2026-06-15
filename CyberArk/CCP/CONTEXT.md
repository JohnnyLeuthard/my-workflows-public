# CCP Workspace Router

Read the user's request and route to the correct CCP stage.

## Routing Rules

| If the request involves... | Route to... |
|----------------------------|-------------|
| Modeling CCP targets, VIPs, GSLB/LTM names, direct hosts, supported ports, TLS/cert notes, environment separation | `stages/01_config_model/CONTEXT.md` |
| Defining request/query inputs such as AppID, Safe, Object, UserName, Address, PlatformID, Reason, or required/optional selector sets | `stages/02_request_catalog/CONTEXT.md` |
| Building or validating request URI patterns from known config and request items, without executing them | `stages/03_uri_builder/CONTEXT.md` |
| Running or documenting approved live endpoint tests against CCP/AIMWebService endpoints | `stages/04_endpoint_testing/CONTEXT.md` |
| Planning an internal user interface, dropdowns/selectors, forms, security restrictions, or deployment approach | `stages/05_interface_planning/CONTEXT.md` |
| Looking up local CCP reference docs, config conventions, or vendor documentation pointers | `references/_INDEX.md` |

## Cross-Stage Flow

Normal CCP work should proceed in this order:

1. `01_config_model` captures where CCP can be reached.
2. `02_request_catalog` captures what can be queried.
3. `03_uri_builder` combines known target and request data into a URI artifact.
4. `04_endpoint_testing` runs only after human approval.
5. `05_interface_planning` turns the workflow into an internal user experience.

## Review Gates

Stop after each produced artifact and wait for explicit human approval before moving to the next stage. Live endpoint testing is always gated, even for DEV.

## Global Constraints

- Load `CLAUDE.md` in this workspace before acting here.
- Load `references/_INDEX.md` before opening any specific reference file.
- Never preload all stage files.
- Never save secrets or unredacted credential responses.
- Never generate mock output in place of real test output.
