# CyberArk CCP Workspace

You are in the CyberArk Central Credential Provider (CCP) sub-workspace. This area is for designing and testing CCP/AAM credential retrieval request flows, including VIP, LTM, GSLB, and direct host connection patterns.

## How to Navigate

Read `CONTEXT.md` in this directory to route the request to the correct CCP stage. Do not load stage files or references until the router identifies what the current task needs.

## Scope

- Model CCP access paths across VIPs, load balancers, GSLB addresses, and direct provider hosts.
- Track supported ports and endpoint variants without assuming every target supports every port.
- Build request item catalogs for query parameters such as application ID, safe, object/account identifiers, username, address, platform, reason, and other vendor-supported selectors.
- Prepare URI-builder and endpoint-test workflows that can later become a user-facing internal interface.
- Keep vendor documentation pointers close to the workspace without copying large vendor content into repo files.

## Safety Rules

- Never commit passwords, returned credential values, API keys, client certificates, private keys, bearer tokens, or session material.
- Do not store live CCP responses unless secrets have been redacted and the user explicitly approves saving the artifact.
- Do not invent endpoint test results. Run the approved script when it exists, or state that no result has been produced.
- Do not run live CCP retrieval tests without explicit human approval for the target environment, host/VIP, port, and request item set.
- Treat DEV, UAT, and PROD separately. If the target tier is not stated for a live test, ask first.

## Vendor Source

Primary vendor documentation starts at:

https://docs.cyberark.com/credential-providers/latest/en/content/landingpages/lp_cpp.htm?tocpath=Developer%7CCentral%20Credential%20Provider%20(CCP)%7C_____0

Before making version-sensitive claims, check `../_config/environment.md` and the relevant vendor documentation for the deployed CCP/AAM version.
