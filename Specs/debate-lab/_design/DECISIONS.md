# Debate Lab — Decision Log

Append-only. Each entry: what was decided, why, and what was rejected. The spec
(`SPEC.md`) records outcomes; this file records reasoning. Never rewrite old
entries — supersede them with new ones.

Entries D1–D24: **2026-07-03**, design phase. Later entries carry their own date inline.

---

## D1. Project name and location: `debate-lab/` at the workspace root

**Why**: Standalone project with its own CLAUDE.md → AGENTS.md → CONTEXT.md chain,
sibling of `icm-teaching-lab/`; router row added at the workspace root per the
workspace's own rule.
**Rejected**: Nesting inside `icm-teaching-lab/` — breaks the one-project-one-folder
routing rule.

## D2. Personas are workspace markdown, not harness agents

**Why**: ICM is a deconstructed agent — a persona is context loaded only when
dispatched (costs nothing until needed), lives in the workspace rather than any
machine's Claude config, and is portable to any tool that can read files.
**Rejected**: Claude Code subagents (`.claude/agents/`) — harness-specific,
machine-oriented, and loaded eagerly rather than on demand.

## D3. A moderator stage owns the run loop

**Why**: Panel resolution, dispatch, and checkpoint routing must live in a file,
not in the agent's head at runtime — logic with no file owner is exactly what ICM
avoids. Also separates three clean roles: moderator runs the debate, master judges
content, personas argue.
**Rejected**: `00-run/` numbered naming (implies a linear order the loop breaks);
folding orchestration into `synthesis/` (merges the two roles the stage exists to
separate).

## D4. Moderator writes only STATUS.md

**Why**: Keep it a pure conductor; run-state recording is the one legitimate
artifact it owns. Everything else is persona or master work.
**Rejected**: A per-round panel note file — redundant once STATUS.md and the report
provenance appendix exist.

## D5. Loop control: human checkpoint after every round

**Why**: The human wants to evaluate each persona's output AND the master's
assessment, add comments, and hold the power to order rebuttal or full reprocess.
Safest while learning the system; the master still does the analytical lifting by
recommending.
**Rejected**: `auto` (master loops on its own — too much trust too early);
`off` (single round only — loses the rebuttal value entirely).

## D6. Max rounds: 2 total (initial + 1 rebuttal)

**Why**: Tightest loop; forces the master to synthesize early. A backstop, not the
main control — the human approves each rebuttal anyway. Raisable by one line in
`debate-settings.md`.
**Rejected**: 3 rounds, 5 rounds, no limit (risky if the human later flips to auto).

## D7. Rebuttal input: master's assessment + the human's comments

**Why**: Focused and cheap; the human's steer is baked directly into the round.
Personas don't wade through each other's full text, and strong-voiced personas
can't anchor the rest.
**Rejected**: Full transcripts (anchoring risk, cost); assessment without human
comments (loses the steer); everything combined (maximum cost for marginal gain).
**Amended in audit**: rebuttal personas also read their *own* previous round file
(can't defend a position they can't see) and the original debate input.

## D8. Rebuttal panel: master recommends, human confirms/adjusts

**Why**: Consistent with D5 — the master's judgment proposes (e.g. only the two
personas in direct conflict), the human disposes.
**Rejected**: Human picks with no recommendation (wastes the master's analysis);
always-everyone (wastes rounds on personas who already agree).

## D9. Reports: per-persona files every round; one final master report

**Why**: The human explicitly wants to see each persona's thinking each round —
what made them change or hold firm. Hence: position accountability (changed-or-held
+ why, mandatory in rebuttals) and a position-evolution section in the final report.
**Rejected**: A polished report per round (more reading, little added value —
round files are the paper trail).

## D10. Starter personas: windows-admin, linux-admin, cyberark-l3, network-engineer, stoic

**Why**: The human's real domain (CyberArk/infrastructure troubleshooting) plus a
deliberately non-technical voice (Marcus Aurelius-style stoic) to prove the lab
handles technical, moral, general, and research debates alike.
**Superseded**: The placeholder set (economist, skeptic, optimist, end-user) from
the first sketch.

## D11. Panel default: all personas on, with three control layers

**Why**: Human's call — all on by default, but controllable: (1) per-persona
`enabled: false` kill switch in CONFIG.md, hard off for half-built or misbehaving
personas; (2) per-debate selection/omission in the input brief or spoken prompt;
(3) roster as a pure index that documents but never controls.
**Rejected**: All-off default with per-debate panels; curated default subset.
**Amended in audit**: an explicit human solo-test request may run a disabled
persona alone (otherwise the HOW-TO's "test before enabling" step is impossible) —
it still can never join a debate panel.

## D12. Persona weight: 1–5 in CONFIG.md, a signal not a veto

**Why**: Human's insight — an L1 engineer's word should carry less than an L3's.
The master factors weight when adjudicating conflicts inside expert domains, but
a good argument still beats rank.

## D13. Per-debate input folders (`input/<job>/`), not single files

**Why**: Human's requirement — one debate needs multiple context files: a brief,
log files, links, anything relevant. Job name comes from the folder name; only
`brief.md` is required.
**Superseded**: The single `raw-issue-<job>.md` file from the first sketch.

## D14. Execution: inline, one persona at a time

**Why**: Simple, portable to any harness, works everywhere. Isolation is by
discipline (fresh read per persona, prior reasoning set aside) — good enough
for v1.
**Rejected**: Spawning disposable subagent workers per persona (true isolation and
parallelism, but ties execution to harnesses that support spawning); noted as a
possible future execution option, not a requirement.

## D15. Persona mechanics live once in `reference/persona-protocol.md`

**Why**: Each persona's AGENTS.md is a four-line pointer; fix the mechanics once
and every persona updates. Creators only ever touch PERSONA.md, EXPERTISE.md,
CONFIG.md — very hard to break a persona.
**Rejected**: Full mechanics copied per persona — ten personas means ten copies
drifting apart.

## D16. CONFIG.md format pinned: two lines, exact values

**Why**: `enabled` and `weight` are machine-parsed every run; fuzzy formats are
where "persona mysteriously didn't run" bugs come from. Malformed → moderator
reports it as misconfigured, never guesses.
**Amended in audit**: the template ships `enabled: false` so the skeleton matches
the start-disabled rule.

## D17. STATUS.md: snapshot + append-only event log, updated after every persona

**Why**: Debates deliberately pause (checkpoints) and accidentally die (token
exhaustion, manual abort, crash). State must live in a file, not session memory.
Updating after every persona completion means a mid-round interruption loses at
most one persona's work. On resume: cross-check the log against files on disk —
logged-complete stands; existing-but-unlogged is partial and re-runs.
**Rejected**: Snapshot only (shows where you are but not how you got there; the
event log also feeds report provenance for free).

## D18. Human comment convention: inline `> COMMENT:` + pre-seeded `## Human Direction`

**Why**: Rebuttal personas must distinguish the human's voice from the master's.
Inline blockquotes give locality (react to the exact claim); the pre-seeded
section holds round-level steer. Marked lines outrank the master's framing, and
personas must explicitly address comments aimed at them.
**Rejected**: Inline only (no home for general steer); section only (comments lose
their connection to specific claims).

## D19. Prerequisite checks per stage; on failure auto-heal once, then stop

**Why**: The teaching lab's verify-before-work rule adapted to fan-out. A missing
persona output is the same situation as an interruption, so reuse the D17 recovery:
re-run once; second failure stops, logs, reports. Never a silent loop, never a
synthesis over a hole.
**Rejected**: Always-stop-and-report (babysitting interruptions for things the
resume logic fixes itself).

## D20. Report provenance: "How this debate ran" appendix at the end

**Why**: Reports travel to peers and management; each must be self-explaining
(panel, weights, rounds, who sat out and why, dates) without opening the folder.
Drawn from the STATUS.md event log. Findings lead; mechanics close.
**Rejected**: Provenance header at the top (pushes findings down); split
top-summary + appendix (more format complexity than value).

## D21. The job folder is the record; reports are views

**Why**: Human's levelset — outputs must be consolidated per debate for reference,
management reporting, later re-analysis, and future ingestion (second brain,
social-media workspace). Canonical `report.md` is never overwritten; derived views
go to `output/<job>/reports/<date>-<audience>.md`; consumers pull on explicit
request, the lab never pushes.
**Related**: Branding/PDF presentation explicitly out of scope — the brandkit
workspace formats a report only on explicit request (same isolation rule).
**Amended in audit**: once `report.md` exists the job is closed (re-debate = new
job name); a reprocess moves displaced rounds to `superseded/<date>/`, never
deletes.

## D22. Two shipped samples: technical + moral

**Why**: First runs should test the machine, not the human's brief-writing — and
both debate types should be demonstrated from day one. `sample-ccp-failure`
(technical, exercises the four technical personas) and `sample-account-maturity`
(moral/policy, the stoic leads).
**Rejected**: Single technical sample (stoic untested in a lead role); single
moral sample (technical guardrails untested).

## D23. Design docs: SPEC.md + DECISIONS.md

**Why**: The design doc outgrew "brief" — it's a build contract (a PRD/spec), and
"brief" collides with the debate inputs' own `brief.md` and the teaching lab's
stage-1 brief. The decision log preserves reasoning that would otherwise live only
in chat history. Two docs per project, no more — proposals and formal ADR files
are ceremony for teams with reviewers.
**Rejected**: Keeping `brief.md` (vocabulary collision); rename-only without a
decision log (loses the whys).

## D24. `_design/` carries a seed chain; the spec carries a Build & Integration Protocol

*(2026-07-03, added after D23 — convention adopted from the teaching lab's `_design/`, its
D11–D13.)*

**Why**: The design folder should be a **drop-in build seed**: copy `_design/` into any
workspace, say "build it out," and the agent self-orients and constructs the lab with no other
context. That requires (1) the folder to be an ICM workspace in miniature — its own
`CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` chain routing build, rebuild, and design-change
requests; (2) the spec to say where to build and how to **plug into the parent workspace**
(router row in the parent `CONTEXT.md`, pointer in `AGENTS.md` if no router, standalone if no
parent chain — always reporting what changed); and (3) rebuilds to preserve human material —
added personas, real inputs, and everything under `output/`, which is the permanent record per
D21. Verification is structural only, since every debate needs the human at the checkpoint (D5) —
no unattended end-to-end run is possible.
**Rejected**: Bare SPEC+DECISIONS only (requires the surrounding workspace to explain what the
folder is — exactly what a drop-in can't assume); build-only seed without parent integration
(manual router wiring defeats "drop it in and ask"); auto-running a sample debate as
verification (would stall at the human checkpoint).

## D25. The lab ships a `HOW-TO-USE.md` user guide at its root

*(2026-07-04.)*

**Why**: Every file in the lab so far instructs the *agent*; nothing explains the lab to a
*person*. The human sits at the center of the loop (checkpoint, comments, verdicts), so the lab
must carry its own plain-language manual: what the lab is, a pointed first run on the shipped
samples, a numbered step-by-step for a real debate (brief → checkpoint → verdict → report), and
quick recipes for the common follow-ups. Spec requirement 12 pins the four sections and their
order. The guide is documentation only — agents still enter through the `CLAUDE.md` →
`AGENTS.md` → `CONTEXT.md` chain, never through the guide — and any design change that alters
the human's interaction must update the guide in the same change, since a stale manual actively
misleads.
**Rejected**: A `docs/` subfolder (one file doesn't need a folder, and root placement is what
makes it findable to a first-time reader); folding usage into the lab's `AGENTS.md` (mixes
audiences — agent instructions and human explanation rot each other); relying on the checkpoint
prompts to teach usage interactively (teaches mid-run, too late for "what is this folder?").
