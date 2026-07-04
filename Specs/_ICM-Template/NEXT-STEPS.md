# Next Steps — This Workspace Is Not Set Up Yet

This folder is a **fresh, minimal copy** of the ICM Workspace Template. It has a front door, an
explainer, and setup machinery — but no stages, no router to real work, no workspace identity.
It is a starting point, not a finished workspace. Here's how to get to finished:

## Path 1 — Guided (recommended)

Point your AI agent at this folder and say **"set up this workspace."**

The agent will ask if you want a short interview (you can stop it at any question), write a
build plan you review and edit, build the workspace checkbox by checkbox — you can do any step
yourself — and finish with an honest audit. The full nine-step walkthrough is in
[README.md](README.md).

When the guided build completes, it **deletes this file automatically**. No `NEXT-STEPS.md` =
setup finished.

## Path 2 — Manual

Build it yourself:

1. Read [docs/explain-icm.md](docs/explain-icm.md) — what a working ICM workspace is made of.
2. Use [reference/icm-checklist.md](reference/icm-checklist.md) as your target — every item
   should pass when you're done.
3. Rewrite `AGENTS.md` and `CONTEXT.md` from seed mode into your workspace's real identity and
   router, and build your stages, reference files, and input/output folders.
4. **Delete this file** when you're done with it — that's the signal (to you, to your agent,
   to anyone else) that this workspace is set up.

Either way: don't leave this file behind in a finished workspace. Its absence is how everyone
knows setup is complete.
