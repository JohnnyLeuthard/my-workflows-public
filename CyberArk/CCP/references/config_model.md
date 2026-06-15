# CCP Config Model Notes

This file defines the intended shape of CCP configuration artifacts. It is not a live configuration file and must not contain secrets.

## Target Types

- `vip`: A general virtual IP or DNS name that fronts one or more CCP servers.
- `ltm`: A local traffic manager endpoint.
- `gslb`: A global load balancing endpoint.
- `host`: A direct CCP server host.

## Port Rules

- VIP, LTM, and GSLB targets may support multiple ports, such as `443` and `8443`.
- Direct host targets should normally map to a single approved port unless the user documents otherwise.
- Do not assume port support from target type alone. Capture the approved ports per target and environment.

## Non-Secret Fields

Future config artifacts may include:

- Environment tier: `DEV`, `UAT`, or `PROD`
- Target display name
- Target type
- Hostname, FQDN, or IP address
- Supported port list
- TLS validation notes
- Path/base endpoint notes
- Owner or support group
- Change/review notes

## Forbidden Fields

Do not store:

- Passwords or retrieved credential values
- API keys or bearer tokens
- Client certificate private keys
- Session cookies
- Unredacted live response bodies
