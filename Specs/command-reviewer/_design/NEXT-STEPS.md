# command-reviewer — Next Steps (planned, not yet designed)

Planned enhancements recorded here before design. Each item, when picked up, goes through the
normal design flow: update `SPEC.md` **and** append a `DECISIONS.md` entry — this file only
holds the intent so it isn't lost. Remove an item from this list when its design lands.

## Open

| Item | Intent | Notes |
|------|--------|-------|
| Filename slug script | Demote output-filename generation from AI inference to a deterministic script (60/30/10: move work from the 10% into the 60%) | Needs a `<name>.md` help file per the parent's scripts rule; intake step 4 would call it instead of improvising |
| Review index | A generated `output/INDEX.md` (or section in output/README.md): every reviewed command with its two scores and verdict, newest first | Makes the archive scannable without opening files; must be regenerated, never hand-maintained |
| Human-approval gate | `Reviewed-by-human: no` header flag the human flips, or a light `03-approve/` stage | From the 60/30/10 oversight discussion — today the close-out invites review but nothing mandates it |
| Standalone repo | Promote `command-reviewer/` to its own GitHub repo for distribution | Currently buried inside the personal workspace; sharing means sharing everything around it |
| Re-review history | Keep superseded reviews (e.g. `<name>.1.md`) instead of overwrite-on-re-review | Only worth designing if re-reviews actually happen in practice |

## Resolved

| Item | Outcome | Where |
|------|---------|-------|
| Chat as the delivery surface | **Designed** (2026-07-12): full review pasted in conversation; file is the archive; path stated without workspace prefix | `DECISIONS.md` D10; SPEC Stage 02 step 5 |
| Stale-filesystem failures | **Designed** (2026-07-12): re-list fresh before dedupe; verify on disk before claiming done | `DECISIONS.md` D11; SPEC Stage 01 step 5 / Stage 02 step 5 |
