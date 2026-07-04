# Interview Guide (Layer 3 — human-editable)

The question areas for the setup interview. Edit this file to tune what gets asked — the
interview *mechanics* (one question at a time, stop-anytime, closing sweep) live in
[AGENTS.md](AGENTS.md) and don't change when this file does.

**The aim**: get to the heart of the problem this workspace will solve — not folder mechanics.
Good answers here mean the plan almost writes itself. Adapt questions to the human's language
and skip areas their earlier answers already covered.

## Question Areas

1. **The problem** — What problem does this workspace solve? For whom? What does "done" or
   "good" look like — how will you know it's working?
2. **Inputs** — What comes in? (requests, documents, logs, data, ideas…) Where from, in what
   form, how messy?
3. **Outputs** — What should come out? (reports, posts, decisions, code, files…) Who consumes
   them, and in what form do they need to be?
4. **Shape of the work** — Is this one flow or several kinds of jobs? Does work move through
   steps (draft → review → final)? Does anything fan out to parallel perspectives and come
   back together? Are there review loops?
5. **Rules and standards** — What must the work respect? Style, tone, quality bars,
   compliance, naming, things that must never happen. (These become `reference/` files.)
6. **Who does what** — Which parts should the AI do, which parts do you want to do yourself,
   and where do you want checkpoints where nothing proceeds without you?
7. **Rhythm and trigger** — How often does work arrive? What kicks a job off — you asking, a
   file landing, a schedule?
8. **What already exists** — Any current material to import or preserve? (documents, half-built
   folders, conventions from another workspace)
9. **Scripts** — If automation beyond markdown turns out to be useful, what language do you
   want scripts in (PowerShell, Python, Bash, other)? Or: none unless we agree otherwise?
   (Whatever the answer — every script ships with a help file, per
   [../reference/scripts-rule.md](../reference/scripts-rule.md).)

## Reminders for the Interviewer

- Open by saying the exit exists: *"Stop me at any question — say 'enough' and I'll work with
  what I have."*
- One question at a time. Follow the thread of their answers; this list is coverage, not
  sequence.
- When you have enough to design the workspace, say so and offer to stop early.
- **Always close with the sweep**: *"Anything important I haven't asked about?"*
- Then write it all to `interview-notes.md` — their words, organized by topic — and invite
  them to edit it before planning begins.
