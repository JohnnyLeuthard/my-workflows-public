# Explain It To Me: How Does This Template Work?

*A plain-language guide to what happens between "I copied a folder" and "I have a working ICM
workspace." For the exact steps, use the walkthrough in [../README.md](../README.md) — this
document explains the ideas behind them.*

---

## The One-Sentence Version

This template is a **seed**: copy it, rename it, point an AI agent at it, and it grows into a
real ICM workspace shaped around *your* problem — with you holding the steering wheel the whole
time.

---

## Two Levels: The Template and Its Copies

The template itself (`_ICM-Template/`) never does any work. It's the master you copy from —
like a rubber stamp. Each **copy**, renamed to a workspace name, is a workspace-to-be. Setup
runs on copies, never on the master. (If an agent is pointed at a folder still named
`_ICM-Template`, it will refuse to set it up and tell you to copy it first.)

## What "Seed Mode" Means

A fresh copy has the standard ICM front door — `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` — but
those files say, honestly: *"this workspace isn't set up yet."* They route setup requests to
the setup machinery and politely refuse real work. That honesty is deliberate: a half-born
workspace should never pretend to be a working one.

Near the end of setup, the agent **rewrites** `AGENTS.md` and `CONTEXT.md` into your
workspace's real identity and router. Seed mode is gone; your workspace's own front door
stands in its place.

## The Ride: Interview → Plan → Build → Audit

Setup follows ICM itself — staged, file-driven, with a checkpoint between every stage:

1. **Interview.** A folder name can't tell the agent what problem you're solving, for whom, or
   what "done" looks like — so it asks. One question at a time, adapted to your answers, and
   **you can stop at any question**. However it ends, the agent asks "anything I haven't asked
   about?" before closing, then writes everything to `_setup/interview-notes.md`. That file —
   not the conversation — is what the design is built from, so read it and fix anything wrong.
2. **Plan.** The agent designs your workspace and writes `_setup/build-plan.md`: the intended
   structure, plus every build step as a checkbox. Nothing is built until you've seen this
   file. Edit it directly — your edits are the approval.
3. **Build.** The agent works through the plan one checkbox at a time, ticking each box the
   moment that step is done. The boxes are the build's memory (see below).
4. **Audit.** The agent checks the finished workspace against
   [../reference/icm-checklist.md](../reference/icm-checklist.md), then critiques its own work
   like an outside reviewer — including "is this the right shape for your problem, not just a
   compliant one?" It writes it all to `_setup/setup-review.md` and fixes nothing without
   your say-so.

## Why Checkboxes? (Interruptions Are Fine)

Sessions die: errors, token limits, closed laptops. The build plan's checkboxes make that
harmless. Each box is ticked immediately after its step — never in batches — so the plan on
disk always shows exactly how far the build got. Any later session told to "resume the setup"
reads the plan, double-checks each ticked box against what's actually on disk, and continues
from the first unchecked one. At most one step's work is ever lost, and the agent never redoes
what's already done.

## You're Always in Charge

The flow is never 100% AI, by design:

- **Stop the interview whenever you want** — every question comes with an exit.
- **Edit any file directly** — interview notes, the build plan, anything. Files are the
  interface, and your edits win.
- **Do build steps yourself** — perform any step by hand and tick its box. The agent treats
  your ticks exactly like its own.
- **Go fully manual** — skip the machinery entirely; `NEXT-STEPS.md` and the checklist show
  the way.

## What's Different After Setup

| Before (fresh copy) | After (your workspace) |
|---------------------|------------------------|
| Front door says "not set up yet" | Front door describes *your* workspace and routes *your* work |
| `NEXT-STEPS.md` sits at the root | **Gone** — its absence is the "setup finished" signal |
| `_setup/` holds machinery only | `_setup/` also holds the record: your interview notes, the fully-ticked plan, the audit — the workspace's birth certificate |
| Generic reference rules | The same rules, now enforced: every script has a help file, the checklist passes |

The record in `_setup/` stays forever. Months later, "why is this workspace shaped this way?"
has a written answer.
