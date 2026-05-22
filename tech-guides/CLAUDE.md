# Tech Guides — MWP Sub-Workspace

You are in `tech-guides/`, a sub-workspace of `my-workflows-public/`. This is a generic technical knowledge base covering infrastructure setup, DevOps tooling, and how-to guides. It started as n8n-focused documentation and expanded to include Docker, Tailscale, GitHub, GCP, and related tooling.

MWP applies recursively here: this sub-workspace has its own `CLAUDE.md` (this file) and `CONTEXT.md` that route into topic folders. Each topic folder holds completed, non-stub guides only.

## How to Navigate

Read `CONTEXT.md` in this directory to route the request to the correct topic folder. Do not open files inside topic folders until you have routed.

## Content Standards

Before contributing or referencing a guide in this workspace, confirm:
- The guide contains real, verified commands or procedures — not placeholder steps.
- The guide does not contain sensitive material (API keys, account-specific IPs, personal credentials, or private hostnames).
- The guide is topic-generic where possible. Tool-specific guides (e.g., n8n) are organized under their own topic folder, not mixed into generic Docker or networking guides.

If you are unsure whether a guide belongs in the public workspace, check `IDEAS.md` — that is where planned or private-only topics live until they are ready to publish.

## Public vs. Private

This workspace is the PUBLIC version. Content is copied here from `my-workflows-private/tech-guides/` after verification and sensitivity review. Do not add content that has not been through that review. The private counterpart follows the same folder structure; see the private repo's `tech-guides/` for in-progress drafts.

## Protocol Rules

See root `CLAUDE.md` for global MWP rules (route-first, layered loading, no simulated data, no inline execution code). Tech-guides-specific additions:

- **No stubs**: Every file must have real content. Planned but unwritten topics belong in `IDEAS.md`, not as placeholder files.
- **No sensitive material**: Strip private IPs, account-specific hostnames, API key values, and personal credentials. Generic placeholders (`YOUR_DOMAIN`, `YOUR_TOKEN`) are fine.
- **Topic folders are flat**: Sub-folders inside topic folders only when a topic accumulates enough guides to warrant grouping. Do not create sub-folders preemptively.
- **Guides are standalone**: Each guide must be self-contained. Cross-references permitted but never required to complete the steps.
- **Private-first workflow**: Draft and verify in the private repo. Copy here only when complete and sanitized.
