# The Scripts Rule (Layer 3 — standing, human-editable)

> **Every script created in this workspace — during setup or ever after — must be accompanied
> by a help file: `<script-name>.md`, in the same folder as the script.**

A script with no help file is a **defect**, not a style issue. The setup audit checks this, and
it stays binding for the life of the workspace.

## Language

This workspace takes no position on scripting language — PowerShell, Python, Bash, JavaScript,
anything the workspace owner chooses (it's an interview question; the answer is recorded in
`_setup/interview-notes.md`). The help-file rule is what's non-negotiable, precisely *because*
the language is anyone's guess: the help file is what makes a script readable to people (and
agents) who don't speak its language.

## What the Help File Must Contain

For a script `sync-reports.ps1`, the file `sync-reports.ps1.md` beside it, covering:

1. **What it does** — one or two plain sentences.
2. **How to run it** — the exact command, with a worked example.
3. **What it needs** — runtime and version, permissions, environment variables, input files.
4. **What it touches** — files/folders it reads, writes, deletes; anything it calls over the
   network.

Short is fine. Missing is not.

## Why This Exists

ICM's promise is that everything the workspace does is readable as plain text. Scripts are the
one place executable logic can sneak in — the help file keeps them inside the promise: anyone
reading the workspace learns what the script does without having to read (or trust their
reading of) the code.
