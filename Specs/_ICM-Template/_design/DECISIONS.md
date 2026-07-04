# ICM Workspace Template — Decision Log

Append-only. Each entry: what was decided, why, and what was rejected. The spec
(`SPEC.md`) records outcomes; this file records reasoning. Never rewrite old
entries — supersede them with new ones.

Entries D1–D11: **2026-07-04**, design phase (from the design interview with the human).
Later entries carry their own date inline.

---

## D1. Name and location: `_ICM-Template/` at the workspace root

**Why**: The underscore marks scaffolding, matching the workspace's existing convention
(`_tmp/`, `_design/`, `personas/_template/`): this folder is copied from, never routed into as a
project doing work. It lives at the root of `my-workspace-new/` but is designed to be lifted out
and shared — nothing in it may depend on this workspace existing around it.
**Rejected**: A plain `icm-template/` project name (reads as a routed project); nesting it under
`ICM-Notes/` (notes are reference material, not scaffolding).

## D2. Ships minimal — basics plus a self-deleting `NEXT-STEPS.md`

**Why**: Human's call — just the basics, but the copy must *say* it's minimal and tell the user
what to do to be successful. `NEXT-STEPS.md` carries that: the guided path (interview) and the
manual path, with a note to simply delete the file if going manual; the guided build deletes it
as its cleanup step, so the file's absence means "setup finished."
**Rejected**: A menu of pattern presets (bigger, more complex template — against "easy, simple,
started quickly"); a bare chain with no guidance (not usable without prior ICM knowledge, and
this is to be shared with others).

## D3. The template's chain ships in seed mode and is rewritten at build

**Why**: A fresh copy is not a workspace yet — its Layer 0/1 must say so, route setup requests
to `_setup/`, and politely refuse "run a job" requests instead of guessing. The build rewrites
`AGENTS.md`/`CONTEXT.md` into the real identity and router, because a finished workspace's front
door must describe what *is*, not what might be.
**Rejected**: Shipping workspace-mode files with placeholder blanks (`<workspace name here>`) —
placeholder text leaks into live workspaces the moment a step is skipped; seed mode fails safe.

## D4. Setup itself follows ICM: four stages owned by one `_setup/AGENTS.md`

**Why**: Human's requirement — the setup work must go through stages per the ICM protocol, with
points where a human can take the reins. Interview → plan → build → audit, each producing a
file, each file a checkpoint. One stage file (not four numbered folders) because the stages are
sequential steps of a single job that runs once per workspace — numbered stage folders are for
re-entrant pipelines, and would bloat a template meant to stay small.
**Rejected**: Numbered `01-interview/`…`04-audit/` folders (ceremony for a run-once process);
no staging at all (setup as one monolithic action — loses the checkpoints and violates the
method the template teaches).

## D5. Interview: exit offered at every question; agent may call "enough"; closing sweep

**Why**: Human's call — the interview ends when the user says so, with the stop offered on
every question so the door is visibly open; the agent may also judge it has enough and offer to
stop early. Either way it must ask "anything important I haven't asked about?" before
concluding — the human knows things the question list doesn't. Question areas live in
`interview-guide.md` (Layer 3) so the interview is tunable without touching stage logic; the
guide aims at the heart of the problem (what problem, for whom, what does done look like), not
at folder mechanics.
**Rejected**: Fixed-length questionnaire (form-filling, not an interview); interview ends only
when the agent decides (human loses control of their own time).

## D6. Between interview and build: a checkbox build plan that is also the resume mechanism

**Why**: Human's requirement — everything captured lands in an MD (`interview-notes.md`), and
the build steps land in an MD the agent can follow, check off, and resume from if interrupted by
an error or token exhaustion. One file serves both needs: `build-plan.md` is the reviewable
design (structure tree + steps) *and* the run state (tick each box immediately after the step,
never in batches; resume = read plan, cross-check disk, continue from first unchecked box).
Same state-lives-in-files principle as the debate lab's `STATUS.md` (its D17), simplified to
checkboxes because build steps — unlike debate rounds — are a flat list.
**Rejected**: Separate plan and status files (two files to keep synchronized, drift guaranteed);
no plan, build straight from interview notes (no review checkpoint, nothing to resume from).

## D7. The human can take the reins at any point; human-ticked boxes count

**Why**: Human's explicit requirement — the flow must never be 100% AI. The mechanism is the
file format itself: the plan is plain markdown, so a person can perform any step by hand and
tick the box; the agent treats human-ticked and agent-ticked identically (the resumption rule's
disk cross-check catches boxes ticked in error either way). The agent must say this when
presenting the plan, or the option exists only in theory.
**Rejected**: An explicit "handoff mode" the human must request (adds protocol where the file
format already provides the capability).

## D8. Scripts: language-agnostic, but every script must ship a help MD

**Why**: Human's call — they have a personal favorite but the template is to be shared, so it
takes no position: PowerShell, Python, Bash, whatever the workspace owner chooses (an interview
topic). Non-negotiable instead: every script created, at setup or ever after, gets a
`<script-name>.md` beside it (what it does, how to run it, what it needs, what it touches). The
rule ships as `reference/scripts-rule.md` and the audit enforces it — an undocumented script is
a defect.
**Rejected**: Recommending a default language (bakes one person's preference into a shared
artifact); help text as a comment header inside the script (not readable by the docs-first ICM
convention, and format varies per language).

## D9. Mandatory post-setup audit: compliance scan + objective critique, written to a file

**Why**: Human's requirement — after any setup, scan the result, verify it adheres to ICM, and
take an objective stance with advice and critical thinking. Two distinct halves, kept distinct:
a mechanical pass/fail walk against `reference/icm-checklist.md` (a shipped, human-editable
yardstick — each item a yes/no question against the filesystem), then a step-back critique as a
reviewer who didn't build it (right structure for the problem? over-engineered? unclear
ownership?). Written to `_setup/setup-review.md`, because spoken advice evaporates. The audit
never silently fixes — it reports; fixes happen on the human's say-so.
**Rejected**: Critique only, no checklist (unfalsifiable, vibes-based compliance); auto-fixing
failures (an auditor that edits what it audits stops being objective).

## D10. Standalone first; both registrations are opt-in

**Why**: Human's call, and the sharing requirement forces it: the template gets dropped into
spaces that don't know it's there, so nothing about it may assume or auto-modify a host. Two
opt-ins: (1) registering the *template itself* in a host router ("start a new ICM workspace →
here") is a README step the human performs or explicitly requests; (2) wiring each *new
workspace* into its parent is a kickoff question, default yes — that one is offered proactively
because a workspace that isn't routed to is invisible, and forgetting the wiring is the likelier
mistake.
**Rejected**: Auto-registering the template on first contact (modifying a host workspace nobody
asked us to touch); standalone-only with no wiring offer (every new workspace starts orphaned).

## D11. `_design/` ships inside the template; `_setup/` is each copy's permanent record

**Why**: Two records, two levels. The design seed (this folder — SPEC, DECISIONS, seed chain)
ships *with* the template so every shared copy carries its own rebuild instructions, per the
drop-in-seed convention (teaching lab and debate lab, debate-lab D24). Separately, each copy's
`_setup/` (interview notes, ticked plan, audit) stays after setup as that workspace's birth
certificate — the rewritten router points "why is this workspace shaped this way?" at it. A
substantial later reshape appends new files (`build-plan-2.md`, …); records are never rewritten.
**Rejected**: Deleting `_setup/` after a successful build (destroys the only record of the
design reasoning); keeping `NEXT-STEPS.md` too (it's a prompt to act, not a record — once setup
is done it is only noise, and its absence is the "setup finished" signal per D2).

## D12. Credits: author's name + GitHub + LinkedIn in the README and the shipped seed

*(2026-07-04, added after the design interview.)*

**Why**: The template is a shared, public artifact — the author's name and links must travel
with it. README gets a short Credits section (Johnny Leuthard; GitHub
<https://github.com/JohnnyLeuthard> as the primary link since that's where the template lives;
LinkedIn <https://www.linkedin.com/in/johnnyleuthard/> as the professional contact — both, since
public shared artifacts conventionally carry both and the human leaned GitHub-primary). The
shipped `_design/AGENTS.md` carries the same credit, because copies get renamed and their
READMEs eventually repurposed, but `_design/` travels with every copy untouched — attribution
survives the copy becoming someone's workspace.
**Rejected**: LICENSE-only attribution (legally present, humanly invisible); stamping the
author's name into files the build creates in new workspaces (those belong to their owners —
credit for the template must not become noise in someone else's project); GitHub-only (LinkedIn
costs one line and is the human's professional face).

## D13. The README's walkthrough is the single authoritative step-by-step

*(2026-07-04, added after the design interview.)*

**Why**: The human requires an exact, numbered, end-to-end guide covering every step of
implementing a workspace from the template — copy, rename, kickoff, the two questions, the
interview (and its exits), plan review, build, resume-on-interruption, audit, done-check. It
lives in one place, `README.md`, and every other file that mentions usage (`NEXT-STEPS.md`,
`docs/explain-this-template.md`) points at it instead of repeating steps — three partial guides
that drift is worse than one complete one. Each step states what the person does, what the agent
does in response, and what exists afterward, so progress is verifiable from the outside.
**Rejected**: Splitting the walkthrough across README/NEXT-STEPS/docs (drift, and no single
complete path); homing it in `NEXT-STEPS.md` (that file is deleted when setup completes — the
guide would vanish with it).

## D14. Master-copy guard: setup refuses to run on a folder still named `_ICM-Template`

*(2026-07-04, added during the build.)*

**Why**: The master and its copies are byte-identical at birth — content can't tell them
apart, but the folder name can: a copy is renamed to its workspace name (spec step 2) before
kickoff (step 3). Without the guard, "set up this workspace" aimed at the master would consume
the template itself — the one folder that must never be set up. Seed `CONTEXT.md` and
`_setup/AGENTS.md` both check the name first and redirect to the copy/rename steps.
**Rejected**: A marker file in the master that copies must delete (one more manual step to
forget, and the copy/rename convention already encodes the distinction); trusting users never
to point an agent at the master (the likeliest first mistake there is).
