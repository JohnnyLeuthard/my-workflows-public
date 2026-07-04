# ICM Workspace Template

*A copy-and-rename seed for starting a brand-new ICM workspace from scratch — an AI agent does
the heavy lifting, you stay in charge the whole way.*

You copy this folder, rename it, and point your AI agent at it. The agent offers you a short
interview to understand what the workspace is for, writes a build plan you can review and edit,
builds the workspace checkbox by checkbox (you can do any step yourself), and finishes with an
honest audit of its own work. If anything gets interrupted, it picks up exactly where it left
off. No code, no app — just folders and markdown files you can read and edit.

New to ICM? Read [docs/explain-icm.md](docs/explain-icm.md) first — it explains the whole
method in plain language. Curious how this template works under the hood? That's
[docs/explain-this-template.md](docs/explain-this-template.md).

---

## What's in the Box

| File / folder | What it is |
|---------------|------------|
| `README.md` | This file — the complete walkthrough. |
| `NEXT-STEPS.md` | The "you are here" note in a fresh copy: what to do right now. Disappears when setup finishes. |
| `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` | The ICM front-door chain, shipped in **seed mode** ("this workspace isn't set up yet"). Setup rewrites the last two into your real workspace's front door. |
| `docs/` | Plain-language explainers: what ICM is, and how this template works. |
| `_setup/` | The setup machinery: the stage instructions and the interview guide. Your interview notes, build plan, and audit report land here too — and stay, as the record of how your workspace was born. |
| `reference/` | Standing rules that survive into your workspace: the ICM checklist (what "done right" looks like) and the scripts rule (every script gets a help file). |
| `_design/` | The template's own build seed — spec and decision log. You never need it to use the template; it ships so any copy can rebuild or explain itself. |

---

## Step by Step: From Template to Working Workspace

This is the single authoritative guide. Nine steps, and for each: what **you** do, what **the
agent** does, and what **exists afterward**.

### 1. Copy the template

**You do**: Copy the entire `_ICM-Template/` folder to wherever the new workspace should live —
inside an existing ICM workspace, or anywhere on its own.
**Afterward**: A fresh, untouched copy sits at the destination. The original template stays
where it was, unchanged.

### 2. Rename the copy to your workspace's name

**You do**: Rename the copied folder to what the workspace is for — `incident-review/`,
`blog-pipeline/`, `vendor-audits/`. Use the name you'd say out loud.
**Afterward**: The folder name *is* the workspace name. Nothing inside hard-codes a name, so
renaming is all it takes.

### 3. Kick off

**You do**: Point your AI agent at the folder and say **"set up this workspace"** (or just ask
it to read the folder).
**The agent does**: Follows the chain (`CLAUDE.md` → `AGENTS.md` → `CONTEXT.md`), sees seed
mode, and routes itself into setup.
**Afterward**: The agent knows where it is and what state the folder is in — and asks you the
two kickoff questions before doing anything else.

### 4. Answer the two kickoff questions

**You do**: Answer:
1. *Interview, or manual?* Take the guided interview (recommended), dictate what you want
   directly, or go fully manual (see [Going Manual](#going-manual)).
2. *Wire into the parent workspace?* If the folder sits inside a workspace with its own ICM
   chain, the agent offers to register your new workspace in the parent's router when the
   build completes. **Default: yes.** (If there's no parent chain, this question is skipped.)
**The agent does**: Records both answers so an interrupted setup never re-asks.
**Afterward**: The setup knows its path and its wiring plan.

### 5. Take the interview (or skip it)

**You do**: Answer questions about what problem the workspace solves, for whom, what comes in,
what should come out, what rules the work must respect, and where you want control points.
Answer in your own words — it's a conversation, not a form. **You can stop at any question**
("enough questions" / "just build it"); the agent reminds you of that up front.
**The agent does**: Asks one question at a time, adapts to your answers, may itself say "I have
enough," and — however it ends — asks one last thing: *"anything important I haven't asked
about?"* Then writes everything captured into `_setup/interview-notes.md`, in your terms.
**Afterward**: `_setup/interview-notes.md` exists. Read it; edit it directly if anything is
wrong or missing — it's the design input for everything that follows.

### 6. Review the build plan

**You do**: Read `_setup/build-plan.md` — the intended folder structure (with one line of
purpose per entry) and every build step as a checkbox. Edit it freely: strike steps, add steps,
reorder. Your edits *are* the approval mechanism. When it looks right, say **go**.
**The agent does**: Designs the workspace from your interview notes, writes the plan, presents
it — and tells you that you can do any step yourself and tick the box by hand.
**Afterward**: An approved plan that is also the build's state: every box unchecked, waiting.

### 7. Let the build run

**You do**: Watch, or help — you can perform any step by hand and tick its box yourself.
Human-ticked and agent-ticked boxes count the same.
**The agent does**: Executes the plan one checkbox at a time, ticking each box **immediately**
after finishing it — never in batches. Late steps include rewriting `AGENTS.md` and
`CONTEXT.md` from seed mode into your workspace's real front door, wiring the parent router (if
you said yes), and deleting `NEXT-STEPS.md`.
**If it gets interrupted** (error, tokens, closed session): just say **"resume the setup"** in
any later session. The agent reads the plan, cross-checks every box against what's actually on
disk, and continues from the first unchecked box. At most one step's work is ever lost.
**Afterward**: Your workspace exists — structure, stages, front door, wiring.

### 8. Read the audit

**You do**: Read `_setup/setup-review.md` and decide which advice to act on. Nothing in it is
auto-applied.
**The agent does**: Walks the finished workspace against
[reference/icm-checklist.md](reference/icm-checklist.md) (pass / fail / n-a, with a fix for
every fail), then steps back and critiques its own build as a reviewer who didn't build it —
is this the *right* structure for your problem, not just a compliant one? It reports; it never
silently fixes.
**Afterward**: A written, honest assessment of your new workspace.

### 9. Confirm you're done

**You do**: Check three things —
- `NEXT-STEPS.md` is **gone** (its absence is the "setup finished" signal),
- the front door (`AGENTS.md` / `CONTEXT.md`) describes **your workspace**, not seed mode,
- `_setup/` holds the record: interview notes, the fully-ticked plan, the audit.
**Afterward**: A working ICM workspace, plus its own birth certificate. Later, if anyone asks
"why is this workspace shaped this way?" — the answer is in `_setup/`.

---

## Going Manual

Prefer to build it yourself? Completely supported — the flow is never AI-only:

- [docs/explain-icm.md](docs/explain-icm.md) tells you what a finished ICM workspace needs.
- [reference/icm-checklist.md](reference/icm-checklist.md) is the target to satisfy.
- `NEXT-STEPS.md` says the same — and once you're done with it, just **delete it** yourself.

You can also mix: take the interview, then do some or all of the build-plan steps by hand and
tick the boxes yourself. The agent treats your ticks exactly like its own.

## Registering This Template with Your Workspace (Optional)

The template is standalone — dropping it into a workspace changes nothing there, and nothing
here modifies your workspace uninvited. If your workspace root has a `CONTEXT.md` router and
you'd like "start a new ICM workspace" requests to land here automatically, add a row yourself
(or ask your agent to):

```markdown
| Starting a new ICM workspace from the template | [_ICM-Template/CLAUDE.md](_ICM-Template/CLAUDE.md) |
```

## Credits

Created by **Johnny Leuthard**
GitHub: <https://github.com/JohnnyLeuthard> — where this template lives
LinkedIn: <https://www.linkedin.com/in/johnnyleuthard/>
