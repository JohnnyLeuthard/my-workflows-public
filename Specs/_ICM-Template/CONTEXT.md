# Seed-Mode Router

This workspace is **not set up yet**. Route requests using the table below — and nothing else.

**Master-copy guard**: if this folder is still named `_ICM-Template`, it is the template
itself, not a workspace-to-be. Do **not** set it up in place — tell the human to copy the
folder to where the new workspace should live, rename the copy, and kick off there
(`README.md`, steps 1–3). Setup runs only on renamed copies.

## Routing Rules

| If the request involves...                                         | Route to...                       |
|---------------------------------------------------------------------|-----------------------------------|
| Setting up this workspace, "build this out", starting the interview, resuming an interrupted setup | [_setup/AGENTS.md](_setup/AGENTS.md) |
| "Explain ICM to me", how this methodology works                     | [docs/explain-icm.md](docs/explain-icm.md) |
| "Explain this template", how setup works, what seed mode means      | [docs/explain-this-template.md](docs/explain-this-template.md) |
| The template's design: why it is built this way, changing or rebuilding the template | [_design/CLAUDE.md](_design/CLAUDE.md) |
| Actual work — "run a job", "process this input", anything that presumes a working workspace | **Stop politely**: *"This workspace isn't set up yet — want to go through setup first?"* Then offer [_setup/AGENTS.md](_setup/AGENTS.md). |

## Standing Rules (survive into the built workspace)

- Every script created here, at setup or ever after, must have a help file beside it — see
  [reference/scripts-rule.md](reference/scripts-rule.md).
- What a finished ICM workspace must look like is defined in
  [reference/icm-checklist.md](reference/icm-checklist.md) — the setup audit's yardstick, and
  the target for anyone building manually.

*Setup's final steps rewrite this file into the real workspace's router. If you are reading
this text inside a workspace that claims to be set up, setup did not finish — check
`_setup/build-plan.md` for the first unchecked box.*
