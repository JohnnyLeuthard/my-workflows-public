# Tech Guides — Router

Read the user's request and route to the correct topic folder.

## Routing Rules

| If the request involves...                                                          | Route to...    |
|-------------------------------------------------------------------------------------|----------------|
| Docker Compose files, container setup, n8n on Docker, upgrades, backups             | `docker/`      |
| n8n hosting options, n8n credentials, n8n connector setup, n8n troubleshooting      | `n8n/`         |
| Tailscale installation, Tailscale troubleshooting, OpenWrt/GL.iNet networking        | `tailscale/`   |
| GitHub tokens, fine-grained PATs, GitHub API access for automation                  | `github/`      |

## Cross-Topic Notes

**n8n on Docker** — Docker setup and Compose → `docker/`. n8n credentials and connectors → `n8n/`. Load both only if the task spans infrastructure setup AND application configuration.

**Tailscale on GCP** — Tailscale install steps → `tailscale/`. GCP VM provisioning → not yet in this workspace (see `IDEAS.md`).

## Global Constraints

- **Route first, then load**: Read only this file and `CLAUDE.md` at the tech-guides root before routing. Do not open files inside topic folders until routed.
- **Guides are standalone**: Load only the specific guide file needed. Do not preload all files in a topic folder.
- **No stubs here**: If a topic has no guide yet, check `IDEAS.md`. Do not create placeholder files.
- **Public content only**: All files have been sanitized. Flag any file that appears to contain sensitive values before using it.

## Adding a Guide

1. Verify real content and passed private-repo review.
2. Strip sensitive material (real IPs, tokens, credentials).
3. Place in matching topic folder with a human-readable filename (no `PREFIX-NNN` scheme).
4. Add a routing row above only if a new topic folder is created.
5. Remove the corresponding `IDEAS.md` entry once published.
