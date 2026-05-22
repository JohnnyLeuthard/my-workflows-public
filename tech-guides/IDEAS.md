# Tech Guides — Planned Topics

Topics that are planned, in-progress in the private repo, or blocked on content readiness.
Remove an entry when the guide is published to a topic folder.

## GCP

- **n8n on GCP: Full Rebuild Guide** — VM creation, Docker install, n8n + Caddy compose, Tailscale, Google OAuth. Rich source material in private repo (GCP-OLD/ narratives). Needs sanitization and rewrite as generic reference.
- **GCP VM SSH Setup** — OS Login vs. metadata SSH keys, key generation, adding public keys to instances.
- **GCP Free-Tier VM Provisioning** — Create e2-micro, assign static IP, open firewall ports.
- **GCP Swap Configuration** — Adding swap on e2-micro VMs to prevent OOM.
- **GCP Service Account + OAuth Credentials** — Create service account, enable APIs, OAuth setup.

## Docker

- **Docker Install on Ubuntu** — apt-based Docker CE install, group membership, verification.
- **Docker Permissions Verification** — Non-root docker access, socket permissions.

## Tailscale

- **Tailscale SSH** — Using `tailscale up --ssh` for key-free private SSH to VMs.
- **Tailscale ACLs** — Access control list basics, restricting peer-to-peer access.

## n8n

- **Google Sheets Connector** — OAuth setup and basic read/write operations.
- **Slack Connector** — Bot token setup and workflow notifications.
- **Email Notifications** — SMTP or Sendgrid setup for workflow error alerts.
- **Backup to GitHub** — Automated workflow JSON export to a Git repo.
- **Reverse Proxy with Caddy** — Caddy config for HTTPS + n8n, SSL auto-provisioning.

## GitHub

- **GitHub SSH Key Setup** — ed25519 key generation, adding to account, testing.

## MCPs

- *(Placeholder — MCP setup documentation not yet started)*

## Terminal / Linux

- *(Candidate: common Linux commands reference — assess whether this fits here or a separate workspace)*
