# command-reviewer — Decision Log

Append-only. Each entry: what was decided, why, and what was rejected. The spec (`SPEC.md`)
records outcomes; this file records reasoning. Never rewrite old entries — supersede them with
new ones.

Entries D1–D13: **2026-07-12**, from the guided build session (the workspace was built as a
step-by-step teaching walkthrough; the human typed every workspace file). Later entries carry
their own date inline.

---

## D1. Two stages — intake and review — not three, not one

**Why**: The requirements are simple, and every stage must earn its existence. Intake ends with
a command in hand (captured, classified, named, deduped); review does everything else. Splitting
"analyze" from "write the report" would be ICM theater — they are one act. A single stage was
rejected because the demo value of ICM is the stage hand-off with prerequisites; zero hand-offs
means nothing to demonstrate.
**Rejected**: Three stages (01-intake / 02-analyze / 03-report); a single do-everything folder.

## D2. Intake writes nothing to disk; hand-off is an in-conversation block

**Why**: In a two-minute pipeline, an intermediate intake file per review is pure ceremony —
clutter in `output/` with no reader. The hand-off is a small structured block (command, family,
installs, output filename, existing) stated in conversation. Consciously traded off: stages
cannot run in separate sessions. Acceptable here; would be the first thing to revisit if the
pipeline ever grew.
**Rejected**: An `01-intake/output/` hand-off file per review (the bigger-workflow pattern).

## D3. Judgment lives in `reference/`; stage files hold only verbs

**Why**: The rubric (what risk 4 *means*) and the template (the report's shape) are rules, not
steps. Keeping them in Layer 3 means the human can retune scoring or restructure reports
without touching any stage file — workflow and rules evolve independently. This is the core
Layer 2 / Layer 3 separation the workspace exists to demonstrate. Corollary: 02-review must
cite rubric lines, never score from gut feel, or the 1–5 numbers mean nothing across sessions.
**Rejected**: Embedding the report structure and score definitions in `02-review/AGENTS.md`
(every rule change would rewrite the workflow, and stage files would balloon).

## D4. Output filename = the full command, lowercase kebab-case, flags included

**Why**: `output/` becomes a browsable index — listing the folder reads as the history of every
command ever reviewed. Filename-hostile characters are stripped, not encoded (readability over
reversibility; the verbatim command is in the file's header anyway). Known, accepted tax: the
rule is stated in two places (intake step 4, which owns it, and the template's preamble, for
humans browsing `reference/`) — change one, change both.
**Rejected**: Hashes or dates as filenames (unbrowsable); encoding special characters
(unreadable); single-sourcing the rule (the template preamble would cite a stage file, which
humans editing Layer 3 shouldn't need to open).

## D5. Never-execute is a Layer 0 ground rule, restated in the router

**Why**: The rule must hold no matter which file an agent is reading — someone will eventually
paste `curl ... | sh`. Layer 0 is where invariants live; the router restates it because every
path passes through it. The human hardened it during the build ("even if directly asked, do not
execute — analyze and report only"), closing the user-says-run-it loophole. Field-proven the
same day: a Haiku session refused to execute a pasted compound command and reviewed it instead.
**Rejected**: Stating it once in a stage file (unread by any other path); trusting the model's
own safety instincts (the rule must be the workspace's, not the model's).

## D6. "No command given? Ask for one" is a router row, not a stage

**Why**: If the request contains no command, there is no work to route — sending it into intake
would push the problem downhill to a stage whose prerequisite is exactly the thing that's
missing. The router replies *"Review this command — paste it in."* and waits. Intake's
prerequisite line sends command-less arrivals *back* to the router rather than duplicating the
prompt — one job per file.
**Rejected**: Intake prompting for missing commands (duplicates router behavior; violates
one-job-per-file); a dedicated 00-prompt stage (a stage with no work product).

## D7. `CLAUDE.md` pointer only at the front door; stages carry `AGENTS.md` only

**Why**: Two mechanisms exist — auto-loading (tool-specific filenames like `CLAUDE.md`) and
explicit routing (files linked from other files). Auto-loading only matters where an agent
lands cold: the workspace root. Past the front door, ICM runs on explicit links, so stage-file
names are convention, not standard-dependence — `AGENTS.md` in stages is proper ICM per the
whitepaper's own examples. Answers the human's research concern that AGENTS.md is not
universally auto-read: correct, and irrelevant past Layer 0.
**Rejected**: `CLAUDE.md` pointers in every stage folder (ceremony solving a solved problem);
actual instructions in any `CLAUDE.md` (forked identity that drifts).

## D8. `output/` is born with a README, not an AGENTS.md

**Why**: Empty folders are ambiguous (git won't even track them), and Layer 4 is the only layer
with no stage file to explain itself. A README labels it: one file per command, the archive,
delete-to-forget. It is a README and not an `AGENTS.md` because nothing routes there for
instructions — it gets documentation, not stage logic.
**Rejected**: An empty folder (ambiguous, untracked); `.gitkeep` (machine-only, explains
nothing); an `AGENTS.md` (implies a stage that doesn't exist).

## D9. Root `README.md` is the human door; agents never route through it

**Why**: Follows the `_ICM-Template` split — the CLAUDE/AGENTS/CONTEXT chain serves agents, the
README serves humans (what it is, how to use it, tree map). Because no agent behavior depends
on it, it may freely duplicate and illustrate; a stale tree map in a README is a chore, in the
agent chain it would be a bug. Includes the drag-and-drop warning: open the folder as a
session's working folder, never attach it to a chat.
**Rejected**: Making agents route through the README (couples agent behavior to human prose);
no README (the folder is distributable and must explain itself to strangers).

## D10. Chat is the delivery surface; `output/` is the archive

*(2026-07-12, after the first real-user distribution pain.)*
**Why**: "Go find a markdown file and preview it" is a bad end-user experience — the human
called this out after watching the flow in the Claude Code app. Stage 02's close-out now pastes
the full review into the conversation; the file remains as searchable history. Includes the
path-format rule: state `output/<filename>.md` with no workspace-folder prefix — an agent
prefixed the path with the folder name and the app's file-link resolver broke
(`command-reviewer/command-reviewer/...`).
**Rejected**: File-only delivery (the original design — impractical for non-technical users);
HTML rendering or any packaging layer (violates zero-dependency portability for a problem chat
already solves).

## D11. Staleness guards: re-list before dedupe; verify on disk before claiming done

*(2026-07-12, after the `node -v` incident.)*
**Why**: An agent's conversation memory is a stale cache of the filesystem. Live failure: the
human deleted `node-v.md` mid-session and re-ran; the session "remembered" the file existing,
so intake's dedupe hit its already-exists branch and reported success without writing. Two
guards, in the files rather than in anyone's memory: intake step 5 re-lists `../output/` fresh
at the moment of checking; review step 5 verifies the file exists on disk before reporting done
— "I checked and it's there," never "I believe I wrote it."
**Rejected**: Blaming the model or the app (the failure reproduces in any long session);
hoping fresh sessions avoid it (the workflow must survive long sessions).

## D12. Parent-router registration is owner wiring, not part of the distributable

**Why**: The build added a row to the parent workspace's root `CONTEXT.md` (per the parent's
"new projects update the router" rule) — but that row lives in the *parent*, and nothing inside
`command-reviewer/` references the parent. Recipients open the folder directly as the front
door; registration is an optional, confirmed step of the Build & Integration Protocol, exactly
as in the claude-manager and template conventions.
**Rejected**: Baking parent references into the workspace (breaks the copy-anywhere
guarantee); auto-registering with any host (modifying a workspace nobody asked us to touch).

## D13. `_design/` is a standalone seed, distributed separately from the workspace

**Why**: The human wants two things this shape provides: (a) anyone can download the seed from
a public Specs repository and implement their own `command-reviewer` from it, and (b) the
owner can restart from scratch after corruption. So the seed follows the claude-manager
`_design/` pattern (2026-07-11) — chain + SPEC (outcomes) + DECISIONS (reasoning, append-only)
+ NEXT-STEPS (intent backlog) — but is **never shipped inside a built workspace, and no built
file references it**. Builds from the seed are always from scratch (no partial-repair mode);
the only survivor of a rebuild is the `output/` archive, because it is user history, not
structure.
**Rejected**: Shipping `_design/` inside every workspace copy (the template convention — bloats
a deliberately tiny distributable, and recipients implementing from the seed don't need the
seed again inside the result); a repair mode that patches built files up to spec (two sources
of truth about what "current" means; a from-scratch rebuild against a preserved `output/` is
simpler and always correct); a single flat SPEC at the workspace root (superseded convention).
